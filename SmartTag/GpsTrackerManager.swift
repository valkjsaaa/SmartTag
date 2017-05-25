//
//  GpsTrackerManager.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import Spark_SDK

class GpsTrackerManager {
    let sharedSparkCloud = SparkCloud.sharedInstance()
    var timer: Timer?
    var gpsTrackers: [GpsTracker]?
    init() {
        self.sharedSparkCloud.login(withUser: "yuanshenlifml@gmail.com", password: "blahblah") { (err) in
            self.sharedSparkCloud.getDevices({ (devices: [SparkDevice]?, err) in
                if let devices = devices {
                    var trackers = [GpsTracker]()
                    for device in devices {
                        if (device.variables["lastLocation"] != nil) {
                            trackers.append(GpsTracker(device: device))
                        }
                    }
                    self.gpsTrackers = trackers
                }
            })
        }
    }
}
