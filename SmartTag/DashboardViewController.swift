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
    var settingsViewController: DashBoardSettingsTableViewController!
    
    var internalShowCriticalItems = false
    var internalShowMyItems = false
    var internalShowItmesToMove = false
    var internalAddGridLines = false
    var internalShowItems = false
    var internalRoutingEnabled = true

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
            settingsViewController = target
            target.delegate = self
        }
        if segue.identifier == embedMapsViewControllerSegueIdentifier {
            mapsViewController = segue.destination as! MapsViewController
            mapsViewController.delegate = self
        }
    }

}

extension DashboardViewController: MapsViewDelegate {
    func refreshSelected() {
        if mapsViewController.selectedGrids.count == 2 {
            internalRoutingEnabled = true
//            settingsViewController.routingButton.isEnabled = true
        } else {
            internalRoutingEnabled = false
//            settingsViewController.routingButton.isEnabled = false
        }
    }
}

extension DashboardViewController: DashBoardSettingsTableViewDelegate {
    func startRouting() {
        if self.mapsViewController.selectedGrids.count != 2 {
            let alert = UIAlertController(title: "Please select two region as start and end region.", message: "First add grid lines, and then select two region in grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
            return
        }
        var boolMap = [[Bool]].init(repeating: [Bool].init(repeating: true, count: self.mapsViewController.cellColCount), count: mapsViewController.cellRowCount)
        for (i, row) in mapsViewController.reservations!.enumerated() {
            for (j, cell) in row.enumerated() {
                if cell?.type != .Available {
                    boolMap[i][j] = false
                }
            }
        }
        let result = ShortestPath(graph: boolMap, start: self.mapsViewController.selectedGrids[0], end: self.mapsViewController.selectedGrids[1])
        guard let indexes = result else {
            let alert = UIAlertController(title: "Two region selected is seperated from the other.", message: "You need to select two region which is accessible via a certain path.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
            return
        }
        for point in indexes {
            self.mapsViewController.addSelectedGrid(point: point)
        }
    }
    var showItems: Bool {
        get {
            return self.internalShowItems
        }
        set(newShowItems) {
            self.internalShowItems = newShowItems
            self.mapsViewController.showItmes = newShowItems
        }
    }
    
    var showCriticalItems: Bool {
        get {
            return self.internalShowCriticalItems
        }
        set(newShowCriticalItems) {
            self.internalShowCriticalItems = newShowCriticalItems
            self.mapsViewController.showCriticalItems = newShowCriticalItems
            self.mapsViewController.refreshTrackedItems()
        }
    }
    var showMyItems: Bool {
        get {
            return internalShowMyItems
        }
        set(newShowMyItems) {
            self.internalShowMyItems = newShowMyItems
            self.mapsViewController.showMyItems = newShowMyItems
            self.mapsViewController.refreshTrackedItems()
        }
    }
    var showItemsToMove: Bool {
        get {
            return internalShowMyItems
        }
        set(newShowItemsToMove) {
            self.internalShowMyItems = newShowItemsToMove
            self.mapsViewController.showItemsToMove = newShowItemsToMove
            self.mapsViewController.refreshTrackedItems()
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

    var dashboard: Bool {
        get {
            return true
        }
    }
    
    var routingEnabled: Bool {
        get {
            return internalRoutingEnabled
        }
    }
}
