package app.aurawell.wear

import androidx.wear.tiles.TileService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Mirrors WatchConfig.tileChannel in packages/watch_protocol.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TILE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "update") {
                    TileService.getUpdater(applicationContext)
                        .requestUpdate(RiskTileService::class.java)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private companion object {
        const val TILE_CHANNEL = "app.aurawell/wear_tile"
    }
}
