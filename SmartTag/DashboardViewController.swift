//
//  DashboardViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    let embedDashBoardSettingsViewSegueIdentifier = "embedDashBoardSettingsView"
    let embedMapsViewControllerSegueIdentifier = "embedMapsViewController"
    
    var mapsViewController: MapsViewController!
    
    var internalShowCriticalItems = false
    var internalShowMyItems = false
    var internalShowItmesToMove = false
    var internalAddGridLines = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == embedDashBoardSettingsViewSegueIdentifier {
            let target = segue.destination as! DashBoardSettingsTableViewController
            target.delegate = self
        }
        if segue.identifier == embedMapsViewControllerSegueIdentifier {
            mapsViewController = segue.destination as! MapsViewController
        }
    }

}

extension DashboardViewController: DashBoardSettingsTableViewDelegate {
    var showCriticalItems: Bool {
        get {
            return self.internalShowCriticalItems
        }
        set(newShowCriticalItems) {
            self.internalShowCriticalItems = newShowCriticalItems
        }
    }
    var showMyItems: Bool {
        get {
            return internalShowMyItems
        }
        set(newShowMyItems) {
            self.internalShowMyItems = newShowMyItems
        }
    }
    var showItemsToMove: Bool {
        get {
            return internalShowMyItems
        }
        set(newShowItemsToMove) {
            self.internalShowMyItems = newShowItemsToMove
        }
    }
    var addGridLines: Bool {
        get {
            return internalAddGridLines
        }
        set(newAddGridLines) {
            self.internalAddGridLines = newAddGridLines
            self.mapsViewController.showGridLines = newAddGridLines
        }
    }
    
}
