package com.example.safetravels

import Config
import DataStoreManager
import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.tasks.await
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import java.util.Date
import java.util.concurrent.TimeUnit

class LocationWorker(appContext: Context, params: WorkerParameters) :
    CoroutineWorker(appContext, params) {

    var config = Config()

    override suspend fun doWork(): Result {
        val hasPermission =
            ContextCompat.checkSelfPermission(
                applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED

        if (!hasPermission) {
            return Result.failure()
        }

        Log.d("LOCATION_WORKER", "trying to send location")

        val savedUrl = DataStoreManager.getApiUrl(applicationContext).first()
        val savedApiKey = DataStoreManager.getApiKey(applicationContext).first()
        config = config.copy(apiUrl = savedUrl ?: "")
        config = config.copy(apiKey = savedApiKey)

        return try {
            val fusedLocationProvider =
                LocationServices.getFusedLocationProviderClient(applicationContext)
            val location: Location? =
                fusedLocationProvider
                    .getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
                    .await()

            location?.let {
                sendLocationToServer(config, it.latitude, it.longitude)
                Result.success()
            }
                ?: Result.success()
        } catch (e: Exception) {
            e.printStackTrace()
            Result.success()
        }
    }
}

fun schedulePeriodicLocationWork(context: Context) {
    /** Only run when connected */
    val constraints = Constraints.Builder()
        .setRequiredNetworkType(NetworkType.CONNECTED)
        .build()

    val periodicWorkRequest =
        PeriodicWorkRequestBuilder<LocationWorker>(15, TimeUnit.MINUTES).setConstraints(constraints)
            .build()

    WorkManager.getInstance(context)
        .enqueueUniquePeriodicWork(
            "LocationPeriodicWork",
            ExistingPeriodicWorkPolicy.KEEP,
            periodicWorkRequest
        )
}

private val client = OkHttpClient()


fun sendLocationToServer(config: Config, lat: Double, lon: Double) {
    // temporary, to be set in config
    // 10.0.2.2 points to http:localhost from emulator
    // val url = "http://10.0.2.2:3000/api/location"
    val url = config.apiUrl
    val path = "${url}/api/location"

    val json =
        JSONObject().apply {
            put("latitude", lat)
            put("longitude", lon)
        }

    val requestBody =
        RequestBody.create(
            "application/json; charset=utf-8".toMediaTypeOrNull(),
            json.toString()
        )

    val request =
        Request.Builder()
            .url(path)
            .addHeader(
                name = "Authorization",
                value = config.apiKey ?: ""
            )
            .post(requestBody)
            .build()

    client.newCall(request)
        .enqueue(
            object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    e.printStackTrace()
                    println("Failed to send location: ${e.message}")
                }

                override fun onResponse(call: Call, response: Response) {
                    response.use {
                        if (!response.isSuccessful) {
                            println("Unexpected code: ${response.code}")
                        } else {
                            println("Location sent successfully: $lat, $lon at ${Date()}")
                            println("Server response: ${response.body?.string()}")
                        }
                    }
                }
            }
        )
}
