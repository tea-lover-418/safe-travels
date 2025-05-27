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

    private fun sendLocationToServer(lat: Double, lon: Double) {
        // Stubbed for now: just log or simulate
        println("Sending location: $lat, $lon at ${Date()}")
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
