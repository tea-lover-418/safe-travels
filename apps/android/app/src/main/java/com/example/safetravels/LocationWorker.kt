package com.example.safetravels

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import androidx.core.content.ContextCompat
import androidx.work.CoroutineWorker
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkerParameters
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import java.util.*
import kotlinx.coroutines.tasks.await
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.WorkManager
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

class LocationWorker(appContext: Context, params: WorkerParameters) :
        CoroutineWorker(appContext, params) {

    override suspend fun doWork(): Result {
        val hasPermission =
                ContextCompat.checkSelfPermission(
                        applicationContext,
                        Manifest.permission.ACCESS_FINE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED

        if (!hasPermission) {
            return Result.failure()
        }

        return try {
            val fusedLocationProvider =
                    LocationServices.getFusedLocationProviderClient(applicationContext)
            val location: Location? =
                    fusedLocationProvider
                            .getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
                            .await()

            location?.let {
                sendLocationToServer(it.latitude, it.longitude)
                Result.success()
            }
                    ?: Result.retry()
        } catch (e: Exception) {
            e.printStackTrace()
            Result.retry()
        }
    }

}

fun schedulePeriodicLocationWork(context: Context) {
    val periodicWorkRequest =
            PeriodicWorkRequestBuilder<LocationWorker>(15, TimeUnit.MINUTES).build()

    WorkManager.getInstance(context)
            .enqueueUniquePeriodicWork(
                    "LocationPeriodicWork",
                    ExistingPeriodicWorkPolicy.REPLACE,
                    periodicWorkRequest
            )
}

private val client = OkHttpClient()

fun sendLocationToServer(lat: Double, lon: Double) {
    val url = "http://10.0.2.2:3000/api/location"  // Use 10.0.2.2 for Android emulator localhost
    val json = JSONObject().apply {
        put("lat", lat)
        put("lon", lon)
    }

    val requestBody = RequestBody.create(
        "application/json; charset=utf-8".toMediaTypeOrNull(),
        json.toString()
    )

    val request = Request.Builder()
        .url(url)
        .post(requestBody)
        .build()

    client.newCall(request).enqueue(object : Callback {
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
    })
}
