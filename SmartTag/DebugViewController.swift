//
//  DebugViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/25/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regenerateDatabase(_ sender: Any) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: ReservationInstance.fetchRequest()))
        try! managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: ReservationDelivery.fetchRequest()))
        try! managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: ReservationDate.fetchRequest()))
        
        for hour in [8, 10, 12, 14, 16] {
            var dateComponents = DateComponents.init()
            dateComponents.day = 24
            dateComponents.month = 5
            dateComponents.year = 2017
            dateComponents.hour = hour
            dateComponents.minute = 0
            dateComponents.second = 0
            let date = Calendar.autoupdatingCurrent.date(from: dateComponents)!
            let reservationDate = ReservationDate(context: managedObjectContext)
            reservationDate.date = date
        }
        try! managedObjectContext.save()
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
