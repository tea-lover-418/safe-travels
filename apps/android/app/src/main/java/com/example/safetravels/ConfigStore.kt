import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore by preferencesDataStore(name = "settings")

object DataStoreManager {
    private val API_URL = stringPreferencesKey("api_url")
    private val API_KEY = stringPreferencesKey("api_key")

    fun getApiUrl(context: Context): Flow<String?> {
        return context.dataStore.data.map { preferences ->
            preferences[API_URL]
        }
    }

    fun getApiKey(context: Context): Flow<String?> {
        return context.dataStore.data.map { preferences ->
            preferences[API_KEY]
        }
    }

    suspend fun saveApiUrl(context: Context, url: String) {
        context.dataStore.edit { preferences ->
            preferences[API_URL] = url
        }
    }

    suspend fun saveApiKey(context: Context, url: String) {
        context.dataStore.edit { preferences ->
            preferences[API_KEY] = url
        }
    }
}
