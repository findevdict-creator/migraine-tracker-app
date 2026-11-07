package app.aurawell.mobile

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget (phase 26): today's level, top factor, pressure
 * trend and a start-attack button. All text is written by the app
 * (HomeWidgetSync) in the person's language; this class only draws it.
 *
 * Mirrors of lib/config/app_config.dart:
 * - class name: AppHomeWidgets.androidProvider
 * - data keys: AppHomeWidgets.key*
 * - start link: AppHomeWidgets.startAttackUri
 */
class RiskWidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val views = RemoteViews(context.packageName, R.layout.risk_widget).apply {
        setTextViewText(
            R.id.widget_level,
            widgetData.getString("levelLabel", null)
                ?: context.getString(R.string.widget_placeholder),
        )
        setTextColor(R.id.widget_level, levelColor(context, widgetData.getString("level", "")))
        setTextViewText(R.id.widget_headline, widgetData.getString("headline", ""))
        setTextViewText(R.id.widget_pressure, widgetData.getString("pressure", ""))
        setTextViewText(R.id.widget_updated, widgetData.getString("updated", ""))
        setTextViewText(
            R.id.widget_start,
            widgetData.getString("startLabel", null)
                ?: context.getString(R.string.widget_start_fallback),
        )

        // Tapping the card opens the app; the button starts (or opens) an attack.
        setOnClickPendingIntent(
            R.id.widget_container,
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
        )
        setOnClickPendingIntent(
            R.id.widget_start,
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(START_ATTACK_URI),
            ),
        )
      }
      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  private fun levelColor(context: Context, level: String?): Int =
      context.getColor(
          when (level) {
            "high" -> R.color.widget_risk_high
            "moderate" -> R.color.widget_risk_moderate
            "low" -> R.color.widget_risk_low
            else -> R.color.widget_text
          },
      )

  companion object {
    const val START_ATTACK_URI = "aurawell://widget/start-attack?homeWidget"
  }
}
