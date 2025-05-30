package com.example.safetravels

import android.Manifest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.example.safetravels.ui.theme.SafeTravelsTheme

class MainActivity : ComponentActivity() {

    private val locationPermissions =
        arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_BACKGROUND_LOCATION,
            Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
        )

    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val permissionLauncher =
            registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) {
                schedulePeriodicLocationWork(this)
            }

        permissionLauncher.launch(locationPermissions)

        setContent {
            SafeTravelsTheme {
                val viewModel: LocationViewModel = viewModel()
                val location = viewModel.location.collectAsState()
                val context = LocalContext.current

                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    topBar = { TopAppBar(title = { Text("Current Location") }) }
                ) { innerPadding ->
                    Column(modifier = Modifier
                        .padding(innerPadding)
                        .padding(16.dp)) {
                        Text("Latitude: ${location.value.first}")
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Longitude: ${location.value.second}")
                        Spacer(modifier = Modifier.height(16.dp))
                        Button(
                            onClick = {
                                val workRequest =
                                    OneTimeWorkRequestBuilder<LocationWorker>().build()
                                WorkManager.getInstance(context).enqueue(workRequest)
                            }
                        ) { Text("Send Location Now") }
                    }
                }
            }
        }
    }
}
