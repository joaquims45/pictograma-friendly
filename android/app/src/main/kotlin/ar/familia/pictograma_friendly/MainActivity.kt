package ar.familia.pictograma_friendly

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ar.familia.pictograma/kiosk")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "start" -> { startLockTask(); result.success(null) }
                        "stop" -> { stopLockTask(); result.success(null) }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("kiosk", e.message, null)
                }
            }
    }
}
