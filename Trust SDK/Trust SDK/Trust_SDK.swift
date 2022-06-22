//
//  Trust_SDK.swift
//  Trust SDK
//
//  Created by QTS Coder on 22/06/2022.
//

import Foundation
import UIKit
public final class Trust_SDK {

    let name = "Trust_SDK"
    
    public init(){
        
    }
    public func get_device_info()-> NSDictionary{
        return ["os": "i", "os_version":self.getOSInfo(), "battery_charging": self.GetbatteryCharging(), "battery_level": self.getBatteryLevel() * 100, "cpu": UIDevice.current.getCPUName(), "free_storage": self.deviceRemainingFreeSpaceInBytes() ?? 0, "gpu_name": "Apple GPU", "gpu_vendor": "Apple Inc", "screen_height": UIScreen.main.bounds.size.height, "screen_width": UIScreen.main.bounds.size.width, "udid": UIDevice.current.identifierForVendor?.uuid ?? ""]
    }
    
    func getOSInfo()->String {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    func GetbatteryCharging()-> Bool{
        if UIDevice.current.batteryState == .unplugged {
            //Not charging
            return false
        } else {
            //Charging
            return true
        }
    }
    
    func getBatteryLevel()-> Float{
        return UIDevice.current.batteryLevel
    }
    
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            // something failed
            return nil
        }
        return freeSize.int64Value
    }
    
}
