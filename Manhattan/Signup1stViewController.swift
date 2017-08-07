//
//  Signup1stViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField

class Signup1stViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfLastName: JJMaterialTextfield!
    @IBOutlet weak var tfFirstName: JJMaterialTextfield!
    
    var delegate: AppDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        btnNext.layer.cornerRadius = btnNext.frame.height / 2
        btnNext.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnNext.layer.borderWidth = 1
        
        tfFirstName.lineColor = UIColor.white
        tfLastName.lineColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onNextTapped(_ sender: Any) {
        if (tfFirstName.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "First Name is required", action: nil)
        } else if (tfLastName.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Last Name is required", action: nil)
        } else {
            delegate?.user = User()
            delegate?.user?.name = tfFirstName.text! + " " + tfLastName.text!
            self.performSegue(withIdentifier: "1To2Segue", sender: nil)
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
