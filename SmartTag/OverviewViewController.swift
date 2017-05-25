//
//  MainViewController.swift
//  SmartTag
//
//  Created by Jackie Yang on 5/17/17.
//  Copyright © 2017 Jackie Yang. All rights reserved.
//
import UIKit

class OverviewViewController: UIViewController {
    
    let presentSigninViewSegueIdentifier = "presentSigninView"
    let embedMapsViewControllerSegueIdentifier = "embedMapsViewController"
    
    var signedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if signedIn == false {
            self.performSegue(withIdentifier: presentSigninViewSegueIdentifier, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == presentSigninViewSegueIdentifier {
            (segue.destination as! SigninViewController).parentView = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeData() -> Void {
        signedIn = true;
    }
}

