//
//  ViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/17/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class SigninViewController: UITableViewController {
    
    var parentView: OverviewViewController?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signIn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.parentView?.initializeData()
        }
    }
}

