//
//  Signup2ndViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import Alamofire
import SwiftyJSON

class Signup2ndViewController: UIViewController {
    
    @IBOutlet weak var checkImg: UIImageView!
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
        btnNext.layer.borderWidth = 0
        
        btnPrev.layer.cornerRadius = btnPrev.frame.height / 2
        btnPrev.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnPrev.layer.borderWidth = 0
        
        btnPrev.layer.cornerRadius = 22
        btnNext.layer.cornerRadius = 22
        
        tfPassword.lineColor = UIColor.white
        tfEmail.lineColor = UIColor.white
        tfEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField == tfEmail && !(tfEmail.text?.isEmpty)! {
            let parameters = ["email": tfEmail.text]
            Alamofire.request(BASE_URL + CHECKEMAIL_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        if swiftyJsonVar["result"].boolValue == true {
                            self.checkImg.image = UIImage(named: "check")
                        } else {
                            self.checkImg.image = UIImage(named: "delete")
                        }
                    }
                    else {
                    }
                    
                } else {
                }
            }
        } else {
            checkImg.image = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNextTapped(_ sender: Any) {
        if (tfEmail.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Email is required", action: nil)
        } else if (tfPassword.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Password is required", action: nil)
        } else if (tfPassword.text?.characters.count)! < 6 {
            delegate?.showAlert(vc: self, msg: "Password must include at least 6 characters", action: nil)
        } else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["email": tfEmail.text]
            Alamofire.request(BASE_URL + CHECKEMAIL_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        if swiftyJsonVar["result"].boolValue == true {
                            self.delegate?.user?.email = self.tfEmail.text
                            self.delegate?.user?.password = self.tfPassword.text
                            self.performSegue(withIdentifier: "2To3Segue", sender: nil)
                        } else {
                            self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                        }
                    }
                    else {
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                    }
                    
                } else {
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
                }
            }
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
