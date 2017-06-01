//
//  DashBoardSettingsTableViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class DashBoardSettingsTableViewController: UITableViewController {
    
    var delegate: DashboardViewController!
    
    let popupReserveInstanceViewControllerSegueIdentifier = "popupReserveInstanceViewController"

    @IBOutlet weak var showCriticalItemsSwitch: UISwitch!
    @IBOutlet weak var showMyItemsSwitch: UISwitch!
    @IBOutlet weak var showItemsToMoveSwitch: UISwitch!
    @IBOutlet weak var addGridLinesSwitch: UISwitch!
    @IBOutlet weak var showTrackedItems: UISwitch!
    @IBOutlet weak var routingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCriticalItemsSwitch.isOn = self.delegate.showCriticalItems
        self.showMyItemsSwitch.isOn = self.delegate.showMyItems
        self.showItemsToMoveSwitch.isOn = self.delegate.showItemsToMove
        self.addGridLinesSwitch.isOn = self.delegate.addGridLines
        self.showTrackedItems.isOn = self.delegate.showItems
        self.routingButton.isEnabled = self.delegate.routingEnabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showCriticalItemsChanged(_ sender: UISwitch) {
        self.delegate.showCriticalItems = sender.isOn
    }
    
    @IBAction func showMyItemsChanged(_ sender: UISwitch) {
        self.delegate.showMyItems = sender.isOn
    }
    
    @IBAction func showItemsToMoveChanged(_ sender: UISwitch) {
        self.delegate.showItemsToMove = sender.isOn
    }
    
    @IBAction func addGridLinesChanged(_ sender: UISwitch) {
        self.delegate.addGridLines = sender.isOn
    }
    
    @IBAction func showTrackedItemsChanged(_ sender: UISwitch) {
        self.delegate.showItems = sender.isOn
    }
    
    @IBAction func startRouting(_ sender: UIButton) {
        self.delegate.startRouting()
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        if self.delegate.mapsViewController.selectedGrids.isEmpty {
            let alert = UIAlertController(title: "Please select a few regions.", message: "You need have one or more region(s) in order to reserve.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
            return
        }
        performSegue(withIdentifier: popupReserveInstanceViewControllerSegueIdentifier, sender: sender)
    }

    @IBAction func clearSelection(_ sender: UIButton) {
        self.delegate.mapsViewController.removeAllSelectedGrid()
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == popupReserveInstanceViewControllerSegueIdentifier {
            let target = segue.destination as! ReserveInstanceViewController
            target.delegate = self.delegate.mapsViewController
            target.reserveInstance = self.delegate.mapsViewController.selectedGrids.map({ (point) in
                return self.delegate.mapsViewController.reservations![point.0][point.1]!
            })
        }
    }
}

protocol DashBoardSettingsTableViewDelegate {
    var showItems: Bool {
        set get
    }
    var showCriticalItems: Bool {
        get set
    }
    var showMyItems: Bool {
        get set
    }
    var showItemsToMove: Bool {
        get set
    }
    var addGridLines: Bool {
        get set
    }
    var routingEnabled: Bool {
        get
    }
    func startRouting()
}
