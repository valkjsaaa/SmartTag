//
//  ItemTrackerViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import MapKit

class ItemTrackerViewController: UIViewController {

    @IBOutlet weak var realMapView: MKMapView!
    var itemTrackers = [ItemTracker]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let trackerManager = (UIApplication.shared.delegate as! AppDelegate).sharedTrackerManager
        if let trackers = trackerManager.gpsTrackers {
            for tracker in trackers {
                itemTrackers.append(ItemTracker(gpsTracker: tracker))
            }
        } else {
            print("Tracker not ready!!!")
        }
        realMapView.addAnnotations(itemTrackers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

@objc class ItemTracker: NSObject {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var deviceName: String?
    var gpsTracker: GpsTracker

    init(gpsTracker: GpsTracker) {
        self.gpsTracker = gpsTracker
        super.init()
        objc_sync_enter(self.gpsTracker.delegates)
        self.gpsTracker.delegates.append(self)
        objc_sync_exit(self.gpsTracker.delegates)
    }
    
    deinit {
        objc_sync_enter(self.gpsTracker.delegates)
        if let index = self.gpsTracker.delegates.index(where: { (delegate) -> Bool in
            return delegate as! ItemTracker === self
        }){
            self.gpsTracker.delegates.remove(at: index)
        }
        objc_sync_exit(self.gpsTracker.delegates)
    }
}

extension ItemTracker: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        set(newCoordinate) {
            latitude = newCoordinate.latitude
            longitude = newCoordinate.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var title: String? {
        set(newTitle) {
            deviceName = newTitle
        }
        get {
            return deviceName
        }
    }
    
    
}

extension ItemTracker: GpsTrackerDelegate {
    func updateLocation(latitude: Double?, longitude: Double?, locationAvailable: Bool, deviceName: String) {
        self.title = deviceName
        if locationAvailable {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        }
    }
}
