import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let kioskChannel = FlutterMethodChannel(name: "com.example.fe_mobile/kiosk",
                                              binaryMessenger: controller.binaryMessenger)
    kioskChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "startKiosk":
        // iOS does not support programmatic guided access initiation on standard consumer apps,
        // but we return true to handle gracefully in cross-platform UI.
        result(true)
      case "stopKiosk":
        result(true)
      case "isKioskEnabled":
        result(UIAccessibility.isGuidedAccessEnabled)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
