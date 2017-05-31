//
//  ReservationDatePickerViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/29/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

class ReservationDatePickerViewController: UIViewController {

    @IBOutlet weak var startDatePickerView: UIPickerView!
    @IBOutlet weak var endDatePickerView: UIPickerView!
    @IBOutlet weak var priorityCodeTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    var availableDates: [ReservationDate]!
    
    var instanceController: ReserveInstanceViewController?
    var startDateIndex: Int = 0
    var endDateIndex: Int = 0
    
    var startDate: ReservationDate {
        get {
            return availableDates[startDateIndex]
        }
    }
    
    var endDate: ReservationDate {
        get {
            return availableDates[endDateIndex]
        }
    }
    
    var selectedDates: [ReservationDate]? {
        get {
            if endDateIndex >= startDateIndex {
                return Array(availableDates[startDateIndex...endDateIndex])
            } else {
                return nil
            }
        }
    }
    
    var priorityCode: Int16? {
        get {
            if let text = priorityCodeTextField.text {
                return Int16(text)
            } else {
                return nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        availableDates = ReservationDate.getAllDatesSorted(context: managedObjectContext)
        
        if let defaultIndex = availableDates.index(of: self.instanceController!.reserveInstance!.date!) {
            startDateIndex = defaultIndex
            endDateIndex = defaultIndex
            startDatePickerView.selectRow(startDateIndex, inComponent: 0, animated: false)
            endDatePickerView.selectRow(endDateIndex, inComponent: 0, animated: false)
        }
        self.priorityCodeTextField.text = "\(self.instanceController!.reserveInstance!.priorityCode)"
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

extension ReservationDatePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableDates[row].dateString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            startDateIndex = row
        } else if pickerView.tag == 1 {
            endDateIndex = row
        }
    }
}

extension ReservationDatePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableDates.count
    }
}
