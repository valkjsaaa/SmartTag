//
//  DashboardViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var settingsViewWidth: NSLayoutConstraint!

    let presentTimePickerSegueIdentifier = "presentTimePicker"
    let embedDashBoardSettingsViewSegueIdentifier = "embedDashBoardSettingsView"
    let embedMapsViewControllerSegueIdentifier = "embedMapsViewController"
    
    let settingsViewDefaultWidth = 300
    
    var mapsViewController: MapsViewController!
    var settingsViewController: DashBoardSettingsTableViewController!
    
    var internalShowCriticalItems = false
    var internalShowMyItems = false
    var internalShowItmesToMove = false
    var internalAddGridLines = false
    var internalShowItems = false
    var internalRoutingEnabled = true
    var internalSettingsViewShown = true
    
    var settingsViewShown: Bool {
        get {
            return internalSettingsViewShown
        }
        set(newSettingsViewShown) {
            if internalSettingsViewShown != newSettingsViewShown {
                internalSettingsViewShown = newSettingsViewShown
                if internalSettingsViewShown {
                    settingsViewWidth.constant = 0
                } else {
                    settingsViewWidth.constant = -CGFloat(settingsViewDefaultWidth)
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    var currentDate: ReservationDate?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        selectedDate = ReservationDate.getAllDatesSorted(context: managedObjectContext)[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSettingsView(_ sender: UIButton) {
        self.settingsViewShown = !self.settingsViewShown
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
        if segue.identifier == presentTimePickerSegueIdentifier {
            if let timePickerViewController = segue.destination as? TimePickerViewController {
                timePickerViewController.delegate = self
            }
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
    
    var initialDate: ReservationDate {
        return self.currentDate!
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

extension DashboardViewController: TimePickerDelegate {
    var selectedDate: ReservationDate? {
        get {
            return self.currentDate
        }
        set(newDate) {
            var dateString: String! {
                if let dateString = newDate?.dateString {
                    return dateString
                } else {
                    return "Not Available"
                }
            }
            timeLabel.text = "Time: " + dateString
            self.currentDate = newDate
            self.mapsViewController.date = newDate
        }
    }
}

