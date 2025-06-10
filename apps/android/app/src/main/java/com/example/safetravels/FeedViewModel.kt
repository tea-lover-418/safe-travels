package com.example.safetravels

import Config
import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.IOException
import java.util.UUID


val config = Config(
    "https://example",
    "shhhhhh"
)


class FeedViewModel() : ViewModel() {

    private val _title = MutableStateFlow("")
    val title = _title.asStateFlow()

    private val _description = MutableStateFlow("")
    val description = _description.asStateFlow()

    private val _imageUris = MutableStateFlow<List<Uri>>(emptyList())
    val imageUris = _imageUris.asStateFlow()

    private val pickedImages = mutableListOf<Pair<String, File>>()

    fun onTitleChange(newTitle: String) {
        _title.value = newTitle
    }

    fun onDescriptionChange(newDescription: String) {
        _description.value = newDescription
    }

    fun onImagesPicked(uris: List<Uri>, context: Context) {
        viewModelScope.launch {
            pickedImages.clear()
            _imageUris.value = uris

            uris.forEach { uri ->
                val name = UUID.randomUUID().toString() + ".jpg"
                val tempFile = File.createTempFile("upload_", name, context.cacheDir)

                context.contentResolver.openInputStream(uri)?.use { input ->
                    tempFile.outputStream().use { output -> input.copyTo(output) }
                }

                pickedImages.add(name to tempFile)
            }
        }

    }

    fun removeImage(uri: Uri) {
        _imageUris.value = _imageUris.value.toMutableList().also {
            it.remove(uri)
        }
    }

    fun onSubmit() {
        Log.d("FEED", "trying to submit new feed")

        viewModelScope.launch {
            val imageFiles = uploadPickedImages(pickedImages)

            sendFeedToServer(_title.value, _description.value, imageFiles)
        }
    }
}

private val client = OkHttpClient()

fun sendFeedToServer(title: String?, description: String?, imageFiles: List<String>) {
    val url = config.apiUrl
    val path = "${url}/api/feed"

    val json =
        JSONObject().apply {
            put("title", title)
            put("description", description)
            put("type", "FeedImage")
            put("images", JSONArray(imageFiles))
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

suspend fun uploadPickedImages(pickedImages: List<Pair<String, File>>): List<String> {
    val uploadedImageFiles = mutableListOf<String>()
    for ((name, file) in pickedImages) {
        val presignedUrl = getPresignedUrlFromBackend(name) ?: continue
        val success = uploadFileToR2(file, presignedUrl)
        if (success) {
            uploadedImageFiles.add(name)
        }
    }
    return uploadedImageFiles
}

suspend fun getPresignedUrlFromBackend(filename: String): String? = withContext(Dispatchers.IO) {
    val url = config.apiUrl
    val path = "${url}/api/get-bucket-url"

    val jsonMediaType = "application/json; charset=utf-8".toMediaTypeOrNull()
    val jsonBody = """{"filename":"$filename"}"""
    val requestBody = jsonBody.toRequestBody(jsonMediaType)

    val request = Request.Builder()
        .url(path)
        .post(requestBody)
        .addHeader(
            name = "Authorization",
            value = config.apiKey ?: ""
        )
        .build()

    client.newCall(request).execute().use { response ->
        if (response.isSuccessful) response.body?.string() else null
    }
}

suspend fun uploadFileToR2(file: File, presignedUrl: String): Boolean =
    withContext(Dispatchers.IO) {
        val mediaType = "image/jpeg".toMediaTypeOrNull() ?: return@withContext false
        val requestBody = file.asRequestBody(mediaType)
        val request = Request.Builder()
            .url(presignedUrl)
            .put(requestBody)
            .build()

        client.newCall(request).execute().use { response ->
            response.isSuccessful
        }
    }

