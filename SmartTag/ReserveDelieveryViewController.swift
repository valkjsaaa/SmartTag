//
//  ReserveDelieveryViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/30/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class ReserveDelieveryViewController: UIViewController {
    var deliveryInstance: ReservationDelivery?
    var delegate: MapsViewController?
    @IBOutlet weak var priorityCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        priorityCodeTextField.text = "\(deliveryInstance?.priorityCode ?? 0)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reserveDelivery(_ sender: UIButton) {
        if let priorityCodeText = priorityCodeTextField.text, let priorityCode = Int16(priorityCodeText) {
            deliveryInstance?.priorityCode = priorityCode
            deliveryInstance?.type = .Reserved
            self.delegate?.refreshDate()
            self.dismiss(animated: true, completion: {
            })
        } else {
            let alert = UIAlertController(title: "Please use a valid priority code.", message: "Priority code can only be a number between 0~32767.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
            self.present(alert, animated: true, completion: {})
        }
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
