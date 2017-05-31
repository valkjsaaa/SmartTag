//
//  ReservationInformationViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/29/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class ReservationInformationViewController: UIViewController {
    
    @IBOutlet weak var informationTextView: UITextView!

    var instanceController: ReserveInstanceViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        informationTextView.text = instanceController?.reserveInstance?.information ?? "No information available"
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
