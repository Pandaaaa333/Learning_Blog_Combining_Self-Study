package com.example.fe_mobile

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fe_mobile/kiosk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startKiosk" -> {
                    try {
                        startLockTask()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "stopKiosk" -> {
                    try {
                        stopLockTask()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "isKioskEnabled" -> {
                    val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    val isInLockTaskMode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        activityManager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
                    } else {
                        activityManager.isInLockTaskMode
                    }
                    result.success(isInLockTaskMode)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
