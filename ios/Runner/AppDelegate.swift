import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Background metadata lookups (see lib/services/metadata/background.dart).
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "metadata-lookup-queue")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
