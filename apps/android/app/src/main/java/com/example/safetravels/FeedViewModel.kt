package com.example.safetravels

import android.util.Log
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException

class FeedViewModel : ViewModel() {

    private val _title = MutableStateFlow("")
    val title = _title.asStateFlow()

    private val _description = MutableStateFlow("")
    val description = _description.asStateFlow()

    fun onTitleChange(newTitle: String) {
        _title.value = newTitle
    }

    fun onDescriptionChange(newDescription: String) {
        _description.value = newDescription
    }

    fun onSubmit() {
        Log.d("FEED", "trying to submit new feed")

        println("Submitted: Title = ${_title.value}, Description = ${_description.value}")
    }
}

fun sendFeedToServer(config: Config, title: String?, description: String?, imageUrls: String?) {
    val url = config.apiUrl
    val path = "${url}/api/feed"

    val json =
        JSONObject().apply {
            put("title", title)
            put("description", description)
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
                    println("Failed to update feed: ${e.message}")
                }

                override fun onResponse(call: Call, response: Response) {
                    response.use {
                        if (!response.isSuccessful) {
                            println("Unexpected code: ${response.code}")
                        } else {
                            println("Server response: ${response.body?.string()}")
                        }
                    }
                }
            }
        )
}
