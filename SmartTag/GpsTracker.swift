//
//  GpsTracker.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import Spark_SDK
import CoreLocation
class GpsTracker {
    var device: SparkDevice
    var locationAvailable: Bool = false
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var delegates = [GpsTrackerDelegate]()
    var deviceName: String?

    init(device: SparkDevice) {
        self.device = device
        deviceName = device.name
        device.getVariable("lastLocation") { (result, err) in
            if let resultString = result as? String {
                self.trySetLocation(resultString: resultString)
            }
        }
        device.subscribeToEvents(withPrefix: "G") { (event, err) in
            if let resultString = event?.data {
                self.trySetLocation(resultString: resultString)
            }
        }
        print("Tracker \(deviceName ?? "NO NAME") created!")
    }
    
    func trySetLocation(resultString: String) {
        if resultString == "" {
            self.locationAvailable = false
        } else {
            (self.latitude, self.longitude) = self.parseString(resultString: resultString)
            if (self.latitude != nil) && (self.longitude != nil) {
                self.locationAvailable = true
            } else {
                self.locationAvailable = false
            }
        }
        objc_sync_enter(delegates)
        print("Tracker \(deviceName ?? "NO NAME") location updated to (\(latitude ?? 0.0), \(longitude ?? 0.0))!")
        for delegate in delegates {
            DispatchQueue.main.async {
                delegate.updateLocation(latitude: self.latitude, longitude: self.longitude, locationAvailable: self.locationAvailable, deviceName: self.deviceName!)
            }
        }
        objc_sync_exit(delegates)
    }
    
    func parseString(resultString: String) -> (Double?, Double?) {
        let components = resultString.components(separatedBy: ",")
        if components.count != 2 {
            return (nil, nil)
        } else {
            return (Double(components[0]), Double(components[1]))
        }
    }
}

protocol GpsTrackerDelegate {
    func updateLocation(latitude: Double?, longitude: Double?, locationAvailable: Bool, deviceName: String)
}
