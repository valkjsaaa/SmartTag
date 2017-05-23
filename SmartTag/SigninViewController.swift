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
//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        for hour in [8, 10, 12, 14, 16] {
//            var dateComponents = DateComponents.init()
//            dateComponents.day = 24
//            dateComponents.month = 5
//            dateComponents.year = 2017
//            dateComponents.hour = hour
//            dateComponents.minute = 0
//            dateComponents.second = 0
//            let date = Calendar.autoupdatingCurrent.date(from: dateComponents)!
//            let reservationDate = ReservationDate(context: managedObjectContext)
//            reservationDate.date = date
//        }
//        try! managedObjectContext.save()
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

