package com.example.safetravels

import DataStoreManager
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

@Composable
fun ConfigForm() {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var url by remember { mutableStateOf(TextFieldValue("")) }
    var apiKey by remember { mutableStateOf(TextFieldValue("")) }
    var errorText by remember { mutableStateOf<String?>(null) }

    // Observe saved value (optional: display default)
    val savedUrl by DataStoreManager.getApiUrl(context).collectAsState(initial = null)
    val savedApiKey by DataStoreManager.getApiKey(context).collectAsState(initial = null)

    LaunchedEffect(savedUrl) {
        savedUrl?.let {
            url = TextFieldValue(it)
        }
        savedApiKey?.let {
            apiKey = TextFieldValue(it)
        }
    }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Text("Enter API URL", style = MaterialTheme.typography.titleMedium)
        Spacer(modifier = Modifier.height(8.dp))
        TextField(
            value = url,
            onValueChange = {
                url = it
                errorText = null
            },
            label = { Text("URL") },
            placeholder = { Text("http://10.0.2.2:3000") },
            isError = errorText != null,
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )
        TextField(
            value = apiKey,
            onValueChange = {
                apiKey = it
                errorText = null
            },
            label = { Text("API key") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth()
        )
        if (errorText != null) {
            Text(
                text = errorText!!,
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.bodySmall
            )
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(
            onClick = {
                if (url.text.isBlank()) {
                    errorText = "URL cannot be empty"
                } else {
                    scope.launch {
                        DataStoreManager.saveApiUrl(context, url.text)
                        DataStoreManager.saveApiKey(context, apiKey.text)
                    }
                }
            },
            modifier = Modifier.align(Alignment.End)
        ) {
            Text("Submit")
        }
    }
}
