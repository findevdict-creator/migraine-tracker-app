import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Daily weather refresh (phase 11). The identifier must match
    // AppBackgroundTasks.weatherRefresh and BGTaskSchedulerPermittedIdentifiers.
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "app.migrainetracker.weatherRefresh",
      frequency: NSNumber(value: 24 * 60 * 60)
    )
    // Local notifications (phase 21): show them in the foreground too and
    // route action presses to the plugin.
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
