package com.example.safetravels

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.example.safetravels.ui.theme.SafeTravelsTheme

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainFeed() {
    SafeTravelsTheme {
        val viewModel: LocationViewModel = viewModel()
        val location = viewModel.location.collectAsState()
        val context = LocalContext.current


        Column(
            modifier = Modifier
                .padding(16.dp)
        ) {
            Text("Current location")
            Spacer(modifier = Modifier.height(8.dp))
            Column(
                modifier = Modifier
                    .padding(16.dp)
            ) {
                Text("Latitude: ${location.value.first}")
                Spacer(modifier = Modifier.height(8.dp))
                Text("Longitude: ${location.value.second}")
            }
            Spacer(modifier = Modifier.height(32.dp))
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
