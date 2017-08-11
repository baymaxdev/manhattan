//
//  AddGroupViewController.swift
//  Manhattan
//
//  Created by gOd on 8/5/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import Alamofire
import SwiftyJSON

class AddGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tfGroupName: JJMaterialTextfield!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var user: User?
    var delegate: AppDelegate?
    var isPhotoChoosen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.layer.cornerRadius = self.view.bounds.width * 0.4 / 2
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = APP_COLOR.cgColor
        
        tfGroupName.lineColor = APP_COLOR
        tfGroupName.enableMaterialPlaceHolder = true
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        initializeUser()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeUser() {
        if (delegate?.isMe())! {
            user = delegate?.user
        } else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["id": delegate?.curUserId]
            Alamofire.request(BASE_URL + GETUSERBYID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.user = User(user: swiftyJsonVar["userInfo"].dictionaryValue)
                    }
                    else {
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                    }
                    
                } else {
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onDone(_ sender: Any) {
        if isPhotoChoosen == false {
            delegate?.showAlert(vc: self, msg: "Please select photo of the group.", action: nil)
        } else if (tfGroupName.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Please input group name.", action: nil)
        } else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["name": tfGroupName.text!, "photo": ""] as [String : Any]
            Alamofire.request(BASE_URL + GROUPCREATE_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                    }
                    else {
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAvatar(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgAvatar.image = info["UIImagePickerControllerEditedImage"] as! UIImage?
        isPhotoChoosen = true
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
