//
//  TimePickerViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/22/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit
import CoreData

class TimePickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!

    var managedObjectContext: NSManagedObjectContext!
    
    var availableDates : [ReservationDate]!
    
    var delegate: TimePickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        availableDates = ReservationDate.getAllDatesSorted(context: managedObjectContext)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let date = self.delegate?.selectedDate {
            if let index = availableDates.index(of: date) {
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchUpSet(_ sender: UIButton) {
        self.dismiss(animated: true) { }
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

extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableDates.count
    }
}

extension TimePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableDates[row].dateString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.selectedDate = availableDates[row]
    }
}

protocol TimePickerDelegate {
    var selectedDate: ReservationDate? {
        get set
    }
}
