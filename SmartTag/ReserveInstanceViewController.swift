//
//  ReserveInstanceViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/29/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class ReserveInstanceViewController: UIViewController {
    var reserveInstance: ReservationInstance?
    var delegate: MapsViewController?
    
    let embedReserveDatePickerViewSegueIdentifier = "embedReserveDatePickerView"
    let embedReserveInformationViewSegueIdentifier = "embedReserveInformationView"
    let embedReserveRequestViewSegueIdentifier = "embedReserveRequestView"

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var segmentViews: [UIView]!

    var embedReserveDatePickerView: ReservationDatePickerViewController!
    var embedReserveInformationView: ReservationInformationViewController!
    var embedReserveRequestView: ReservationRequestViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segmentChanged(segmentControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        for view in segmentViews {
            if view.tag == sender.selectedSegmentIndex {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }

    @IBAction func reserve(_ sender: UIButton) {
        guard let selectedDates = embedReserveDatePickerView.selectedDates else {
            let alert = UIAlertController(title: "Please select a valid date.", message: "End date must be after the start date.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
            return
        }
        guard let priorityCode = embedReserveDatePickerView.priorityCode else {
            let alert = UIAlertController(title: "Please use a valid priority code.", message: "Priority code can only be a number between 0~32767.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
            return
        }
        var selectedInstances = [ReservationInstance]()
        for date in selectedDates {
            for instance in date.reservedInstances! {
                if instance.x == reserveInstance!.x && instance.y == reserveInstance!.y {
                    if instance.type != .Available {
                        let alert = UIAlertController(title: "Region not available.", message: "Region is \(instance.type.description.lowercased()) at \(instance.date!.dateString!).", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
                        self.present(alert, animated: true, completion: {})
                        return
                    }
                    selectedInstances += [instance]
                }
            }
        }
        let requestString = embedReserveRequestView.requestTextView.text!
        for instance in selectedInstances {
            instance.type = .Reserved
            instance.request = requestString
            instance.priorityCode = priorityCode
        }
        delegate?.refreshDate()
        self.dismiss(animated: true) {}
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case embedReserveDatePickerViewSegueIdentifier:
            embedReserveDatePickerView = segue.destination as! ReservationDatePickerViewController
            embedReserveDatePickerView.instanceController = self
        case embedReserveInformationViewSegueIdentifier:
            embedReserveInformationView = segue.destination as! ReservationInformationViewController
            embedReserveInformationView.instanceController = self
        case embedReserveRequestViewSegueIdentifier:
            embedReserveRequestView = segue.destination as! ReservationRequestViewController
            embedReserveRequestView.instanceController = self
        default:
            break
        }
    }

}
