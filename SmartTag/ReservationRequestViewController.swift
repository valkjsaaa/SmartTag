//
//  ReservationRequestViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/29/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//

import UIKit

class ReservationRequestViewController: UIViewController {
    
    @IBOutlet weak var requestTextView: UITextView!

    var instanceController: ReserveInstanceViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var sameText = true
        for instance in instanceController!.reserveInstance! {
            if instance.request != instanceController!.reserveInstance![0].request {
                sameText = false
            }
        }
        if sameText {
            requestTextView.text = instanceController!.reserveInstance![0].request
        } else {
            requestTextView.text = "(Multiple Value)"
        }
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
