//
//  Signup3rdViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import Alamofire
import SwiftyJSON

class Signup3rdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tfUsername: JJMaterialTextfield!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.layer.cornerRadius = self.view.bounds.width * 0.4 / 2
        
        btnNext.layer.cornerRadius = btnNext.frame.height / 2
        btnNext.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnNext.layer.borderWidth = 1
        
        btnPrev.layer.cornerRadius = btnPrev.frame.height / 2
        btnPrev.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnPrev.layer.borderWidth = 1
        
        tfUsername.lineColor = UIColor.white
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
        if (tfUsername.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Username is required", action: nil)
        }
        else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["username": tfUsername.text]
            Alamofire.request(BASE_URL + CHECKUSERNAME_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        if swiftyJsonVar["result"].boolValue == true {
                            self.delegate?.user?.userName = self.tfUsername.text
                            self.performSegue(withIdentifier: "3To4Segue", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! Signup4thViewController
        vc.image = imgAvatar.image
    }
    
    @IBAction func onPrevTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAvatarTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgAvatar.image = info["UIImagePickerControllerEditedImage"] as! UIImage?
        self.dismiss(animated: true, completion: nil)
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
