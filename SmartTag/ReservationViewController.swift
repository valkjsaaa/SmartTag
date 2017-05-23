//
//  ReservationViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/22/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

class ReservationViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!

    let presentTimePickerSegueIdentifier = "ReservationPresentTimePicker"
    
    var managedObjectContext: NSManagedObjectContext!
    
    var currentDate: ReservationDate?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        selectedDate = ReservationDate.getAllDatesSorted(context: managedObjectContext)[0]
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
        if segue.identifier == presentTimePickerSegueIdentifier {
            if let timePickerViewController = segue.destination as? TimePickerViewController {
                timePickerViewController.delegate = self
            }
        }
    }

}

extension ReservationViewController: TimePickerDelegate {
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
        }
    }
}
