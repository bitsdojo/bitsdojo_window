import Cocoa
import FlutterMacOS

public class BitsdojoWindowPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bitsdojo/window", binaryMessenger: registrar.messenger)
    let instance = BitsdojoWindowPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {    
    switch call.method {
    /*
     // TODO: implement this for channel methods
     case "getAppWindow":
        getAppWindow(call, result)
    */
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
