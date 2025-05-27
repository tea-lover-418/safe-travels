package com.example.safetravels

import android.Manifest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
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
                    Manifest.permission.ACCESS_COARSE_LOCATION
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
                val context = LocalContext.current  // 👈 fix here

                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    topBar = { TopAppBar(title = { Text("Current Location") }) }
                ) { innerPadding ->
                    Column(modifier = Modifier.padding(innerPadding).padding(16.dp)) {
                        Text("Latitude: ${location.value.first}")
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Longitude: ${location.value.second}")

                        Button(onClick = {
                            val workRequest = OneTimeWorkRequestBuilder<LocationWorker>().build()
                            WorkManager.getInstance(context).enqueue(workRequest)
                        }) {
                            Text("Send Location Now")
                        }
                    }
                }
            }
        }
    }
}
