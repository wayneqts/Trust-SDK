//
//  Trust_SDK.swift
//  Trust SDK
//
//  Created by QTS Coder on 22/06/2022.
//

import Foundation
import UIKit
import AdSupport
import ExternalAccessory
import SystemConfiguration.CaptiveNetwork
import MachO
import CoreNFC
import AVFoundation
public final class Trust_SDK {
    let name = "Trust_SDK"
    public init(){
        
    }
    public func get_device_info()-> NSDictionary{
        return [
            "aaid": self.identifierForAdvertising() ?? "",
            "accessories": self.countAccessories(),
            "adid": self.identifierForAdvertising() ?? "",
            "pencil": self.isPencialDevice(),
            "battery_charging": self.getBatteryCharging(),
            "battery_level": self.getBatteryLevel() ,
            "bluetooth_mac_address": "-",
            "camera_megapixel": "-",
            "cpu": UIDevice.current.getCPUName(),
            "cpu_cores": self.getCpuCore(),
            "cpu_type": self.getArch() ?? "",
            "css_image_loaded": false,
            "developer_settings": false,
            "display_zoom": false,
            "ds_card": false,
            "eid": "-",
            "free_storage": self.deviceRemainingFreeSpaceInBytes() ?? 0,
            "gpu_name": "-",
            "gpu_vendor": "-",
            "guided_access": self.isGuidedAccess(),
            "iccid" : "-",
            "icloud_ubiquti_token": "-",
            "identifier": self.getIdentifier(),
            "imei" :"-",
            "imsi": "-",
            "language": self.getLanguage(),
            "latitude": "-",
            "longitude": "-",
            "local_language": self.getLocalLanguage(),
            "low_power_mode": self.isLowPowerMode(),
            "name": UIDevice.current.name,
            "nfc_enabled": self.isEnableNFC(),
            "os":"i",
            "os_version": self.getOSInfo(),
            "physical_memory": ProcessInfo.processInfo.physicalMemory,
            "ringer_mode": "-",
            "root_hiders": "-",
            "rooted": UIDevice.current.isJailBroken,
            "screen_brightness": UIScreen.main.brightness,
            "screen_dpi": self.screenPPIAndDPI(),
            "screen_height": UIScreen.main.bounds.size.height,
            "screen_ppi": self.screenPPIAndDPI(),
            "screen_width": UIScreen.main.bounds.size.width,
            "screen_resolution": self.getScreenResolution(),
            "screen_touch": "-",
            "seid": "-",
            "storage_capacity": UIDevice.current.totalDiskSpaceInBytes(),
            "total_applications" : "-",
            "udid": self.getIdentifier(),
            "unlock_type": "-",
            "virtual_env": "-",
            "ip": self.getIPAddress(),
            "mobile": self.isMobile(),
            "wifi_bssid": "-",
            "wifi_ssid": "-",
            "wifi_security": "-",
            "wifi_mac_address": "-"
        ]
    }
    
    private func getScreenResolution()-> String{
        let width = UIScreen.main.nativeBounds.size.width
        let height = UIScreen.main.nativeBounds.size.height
        return "\(width) x \(height)"
        
    }
    
    private func getOSInfo()->String {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    private func getLanguage()-> String{
        let locale = Locale.current
        guard let languageCode = locale.languageCode,
              let regionCode = locale.regionCode else {
            return ""
        }
        return languageCode + "_" + regionCode
    }
    
    private func getLocalLanguage()-> String{
        let language = Locale.preferredLanguages.first
        return language ?? ""
    }
    
    
    private func getBatteryCharging()-> Bool{
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryState == .charging {
            return true
        } else {
            return false
        }
    }
    
    private func getBatteryLevel()-> Float{
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel * 100
        return batteryLevel
    }
    
    private func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            return nil
        }
        return freeSize.int64Value
    }
    
    
    private func identifierForAdvertising() -> String? {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        // Get and return IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    
    private func countAccessories()-> Int{
        let accessCount = EAAccessoryManager.shared().connectedAccessories.count
        return accessCount
    }
    
    
    // Check pencil for device
    private func isPencialDevice()->Bool{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && UIScreen.main.traitCollection.forceTouchCapability == .available{
            return true
        }
        return false
    }
    
    private func getCpuCore()->Int{
        return ProcessInfo.processInfo.activeProcessorCount
    }
    
    private func getArch() -> String? {
        guard let archRaw = NXGetLocalArchInfo().pointee.name else {
            return nil
        }
        return String(cString: archRaw)
    }
    
    private func isGuidedAccess()-> Bool{
        if UIAccessibility.isGuidedAccessEnabled {
            return true
        }  else {
            return false
        }
    }
    
    private func getIdentifier()->String{
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        return uuid ?? ""
    }
    
    private func isLowPowerMode()-> Bool{
        if ProcessInfo.processInfo.isLowPowerModeEnabled{
            return true
        }
        return false
    }
    
    private func isEnableNFC()->Bool{
        if #available(iOS 11.0, *) {
            if NFCNDEFReaderSession.readingAvailable {
                return true
            }
            else {
                return false
            }
        }
        else{
            return false
        }
    }
    
    private func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
    private func isMobile()-> Bool{
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }
        return false
    }
    
    private func screenPPIAndDPI()-> Int{
        return Int(UIScreen.main.nativeScale * (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? 132 : 163))
    }
    
}
