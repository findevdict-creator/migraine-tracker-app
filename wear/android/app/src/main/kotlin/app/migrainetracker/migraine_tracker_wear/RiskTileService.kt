package app.migrainetracker.migraine_tracker_wear

import android.content.Context
import androidx.concurrent.futures.CallbackToFutureAdapter
import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders.argb
import androidx.wear.protolayout.DimensionBuilders.dp
import androidx.wear.protolayout.DimensionBuilders.expand
import androidx.wear.protolayout.DimensionBuilders.sp
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.ListenableFuture

/**
 * Today's level, the top factor and the pressure line, drawn from the
 * strings the Flutter side stored when the phone last sent a state. Tapping
 * the tile opens the app. The tile never formats or translates anything.
 */
class RiskTileService : TileService() {
    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<TileBuilders.Tile> {
        val prefs = getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        fun text(key: String) = prefs.getString(FLUTTER_PREFIX + key, null) ?: ""

        val levelLabel = text(KEY_LEVEL_LABEL).ifEmpty { getString(R.string.tile_empty) }
        val levelColor = text(KEY_LEVEL_COLOR).toLongOrNull()?.toInt() ?: WHITE

        val column = LayoutElementBuilders.Column.Builder()
            .setWidth(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .addContent(label(levelLabel, 18f, levelColor, bold = true))
            .addContent(spacer())
            .addContent(label(text(KEY_HEADLINE), 13f, WHITE))
            .addContent(spacer())
            .addContent(label(text(KEY_PRESSURE), 13f, GREY))
            .build()

        val open = ActionBuilders.LaunchAction.Builder()
            .setAndroidActivity(
                ActionBuilders.AndroidActivity.Builder()
                    .setPackageName(packageName)
                    .setClassName(MainActivity::class.java.name)
                    .build(),
            )
            .build()

        val root = LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHeight(expand())
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setClickable(
                        ModifiersBuilders.Clickable.Builder()
                            .setId("open")
                            .setOnClick(open)
                            .build(),
                    )
                    .build(),
            )
            .addContent(column)
            .build()

        val tile = TileBuilders.Tile.Builder()
            .setResourcesVersion(RESOURCES_VERSION)
            .setFreshnessIntervalMillis(FRESHNESS_MILLIS)
            .setTileTimeline(TimelineBuilders.Timeline.fromLayoutElement(root))
            .build()
        return CallbackToFutureAdapter.getFuture { completer ->
            completer.set(tile)
            "risk tile"
        }
    }

    override fun onTileResourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest,
    ): ListenableFuture<ResourceBuilders.Resources> {
        val resources = ResourceBuilders.Resources.Builder()
            .setVersion(RESOURCES_VERSION)
            .build()
        return CallbackToFutureAdapter.getFuture { completer ->
            completer.set(resources)
            "risk tile resources"
        }
    }

    private fun label(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean = false,
    ): LayoutElementBuilders.LayoutElement {
        val style = LayoutElementBuilders.FontStyle.Builder()
            .setSize(sp(size))
            .setColor(argb(color))
        if (bold) style.setWeight(LayoutElementBuilders.FONT_WEIGHT_BOLD)
        return LayoutElementBuilders.Text.Builder()
            .setText(value)
            .setMaxLines(2)
            .setFontStyle(style.build())
            .build()
    }

    private fun spacer(): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Spacer.Builder().setHeight(dp(4f)).build()

    private companion object {
        // shared_preferences stores Flutter values in this file, with this
        // prefix. The keys mirror WatchConfig in packages/watch_protocol.
        const val PREFS = "FlutterSharedPreferences"
        const val FLUTTER_PREFIX = "flutter."
        const val KEY_LEVEL_LABEL = "tile.levelLabel"
        const val KEY_HEADLINE = "tile.headline"
        const val KEY_PRESSURE = "tile.pressure"
        const val KEY_LEVEL_COLOR = "tile.levelColor"

        const val RESOURCES_VERSION = "1"

        // Mirrors WatchConfig.tileFreshness (30 minutes).
        const val FRESHNESS_MILLIS = 30L * 60L * 1000L

        val WHITE: Int = 0xFFFFFFFF.toInt()
        val GREY: Int = 0xFFBDBDBD.toInt()
    }
}
