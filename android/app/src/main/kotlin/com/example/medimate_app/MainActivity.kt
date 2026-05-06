package com.example.medimate_app

import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.medimate_app/alarm_uri"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAlarmUri") {
                val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                result.success(uri.toString())
            } else {
                result.notImplemented()
            }
        }
    }
}
