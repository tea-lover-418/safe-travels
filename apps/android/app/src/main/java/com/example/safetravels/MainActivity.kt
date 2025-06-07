package com.example.safetravels

import android.Manifest
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier


class MainActivity : ComponentActivity() {

    private val locationPermissions =
        arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
        )

    private val backgroundPermissions = arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION)

    override fun onStart() {
        super.onStart()

        val permissionLauncher =
            registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) {
                Log.d("INFO", "requesting permission")
                schedulePeriodicLocationWork(this)
            }

        permissionLauncher.launch(locationPermissions)
        permissionLauncher.launch(
            backgroundPermissions
        ) // TODO: doesn't get triggered now until re-render

        // TODO: Bring this to something in the config
        // val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
        // startActivity(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent { MaterialTheme { AppWithTabs() } }
    }

    @OptIn(ExperimentalMaterial3Api::class)
    @Composable
    fun AppWithTabs() {
        var selectedTab by remember { mutableStateOf(0) }
        val tabs = listOf("Main", "Config")

        Scaffold(
            topBar = {
                Column {
                    TopAppBar(title = { Text("Safe Travels") })
                    TabRow(selectedTabIndex = selectedTab) {
                        tabs.forEachIndexed { index, title ->
                            Tab(
                                selected = selectedTab == index,
                                onClick = { selectedTab = index },
                                text = { Text(title) }
                            )
                        }
                    }
                }
            }
        ) { padding ->
            Box(modifier = Modifier.padding(padding)) {
                when (selectedTab) {
                    0 -> MainFeed()
                    1 -> ConfigForm()
                }
            }
        }
    }
}
