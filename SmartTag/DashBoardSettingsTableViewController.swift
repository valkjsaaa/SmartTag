//
//  DashBoardSettingsTableViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class DashBoardSettingsTableViewController: UITableViewController {
    
    var delegate: DashBoardSettingsTableViewDelegate!

    @IBOutlet weak var showCriticalItemsSwitch: UISwitch!
    @IBOutlet weak var showMyItemsSwitch: UISwitch!
    @IBOutlet weak var showItemsToMoveSwitch: UISwitch!
    @IBOutlet weak var addGridLinesSwitch: UISwitch!
    @IBOutlet weak var showTrackedItems: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCriticalItemsSwitch.isOn = self.delegate.showCriticalItems
        self.showMyItemsSwitch.isOn = self.delegate.showMyItems
        self.showItemsToMoveSwitch.isOn = self.delegate.showItemsToMove
        self.addGridLinesSwitch.isOn = self.delegate.addGridLines
        self.showTrackedItems.isOn = self.delegate.showItems
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
}
