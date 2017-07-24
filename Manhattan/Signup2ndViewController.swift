//
//  Signup2ndViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField

class Signup2ndViewController: UIViewController {
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfPassword: JJMaterialTextfield!
    @IBOutlet weak var tfEmail: JJMaterialTextfield!
    
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        btnNext.layer.cornerRadius = btnNext.frame.height / 2
        btnNext.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnNext.layer.borderWidth = 1
        
        btnPrev.layer.cornerRadius = btnPrev.frame.height / 2
        btnPrev.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnPrev.layer.borderWidth = 1
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
        if (tfEmail.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Email is required")
        } else if (tfPassword.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Password is required")
        } else {
            delegate?.user?.email = tfEmail.text
            self.performSegue(withIdentifier: "2To3Segue", sender: nil)
        }
    }
    
    @IBAction func onPrevTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
