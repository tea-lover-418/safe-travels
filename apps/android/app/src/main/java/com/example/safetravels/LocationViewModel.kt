package com.example.safetravels

import android.Manifest
import android.app.Application
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.lifecycle.AndroidViewModel
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

class LocationViewModel(application: Application) : AndroidViewModel(application) {

    private val fusedLocationProvider = LocationServices.getFusedLocationProviderClient(application)

    private val _location = MutableStateFlow(Pair("Unknown", "Unknown"))
    val location: StateFlow<Pair<String, String>> = _location

    init {
        getCurrentLocation()
    }

    private fun getCurrentLocation() {
        CoroutineScope(Dispatchers.IO).launch {
            val context = getApplication<Application>()

            val hasPermission =
                    ContextCompat.checkSelfPermission(
                            context,
                            Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED

            if (!hasPermission) {
                _location.value = Pair("No permission", "No permission")
                return@launch
            }

            try {
                val location =
                        LocationServices.getFusedLocationProviderClient(context)
                                .getCurrentLocation(
                                        com.google.android.gms.location.Priority
                                                .PRIORITY_HIGH_ACCURACY,
                                        null
                                )
                                .await()

                location?.let {
                    _location.value = Pair(it.latitude.toString(), it.longitude.toString())
                }
                        ?: run { _location.value = Pair("Unavailable", "Unavailable") }
            } catch (e: Exception) {
                _location.value = Pair("Error", "Error")
            }
        }
    }
}
