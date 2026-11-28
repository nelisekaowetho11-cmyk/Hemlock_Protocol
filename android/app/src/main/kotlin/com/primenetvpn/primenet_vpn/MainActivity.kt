
package com.primenetvpn.primenet_vpn

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PrimeNetProfileStorage(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL =
            "com.primenetvpn/profile_storage"

        private const val PREFS =
            "primenet_vpn_profiles"

        private const val KEY_PROFILES =
            "saved_profiles"
    }

    fun register(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val preferences = context.getSharedPreferences(
            PREFS,
            Context.MODE_PRIVATE
        )

        when (call.method) {
            "loadProfiles" -> {
                val data = preferences.getString(
                    KEY_PROFILES,
                    "[]"
                ) ?: "[]"

                result.success(data)
            }

            "saveProfiles" -> {
                val data = call.argument<String>("data")

                if (data == null) {
                    result.error(
                        "INVALID_DATA",
                        "Profile data is missing.",
                        null
                    )
                    return
                }

                val saved = preferences.edit()
                    .putString(KEY_PROFILES, data)
                    .commit()

                if (saved) {
                    result.success(null)
                } else {
                    result.error(
                        "SAVE_FAILED",
                        "Could not save profiles.",
                        null
                    )
                }
            }

            else -> result.notImplemented()
        }
    }
}
