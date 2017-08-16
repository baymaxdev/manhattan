//
//  PhotoPostViewController.swift
//  Manhattan
//
//  Created by gOd on 7/28/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PhotoPostViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tfDescription: FloatLabelTextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        btnChoose.layer.cornerRadius = btnChoose.frame.height / 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(_ sender: Any) {
        if (tfDescription.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Description field is required.", action: nil)
        }
        else {
            let parameters = ["userId": delegate?.user?.id, "type": "P", "postTitle": tfDescription.text, "postContent": ""] as [String : Any]
            delegate?.showLoader(vc: self)
            
            Alamofire.request(BASE_URL + POST_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    
                    
                    if swiftyJsonVar["success"].boolValue == true {
                        let action = UIAlertAction(title: "OK", style: .default){ action in
                            self.navigationController?.popViewController(animated: true)
                        }
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
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
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChoosePhoto(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take a Photo", style: .default) { (_ alert: UIAlertAction) in
            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                picker.showsCameraControls = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
            else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, this device has no camera.", action: nil)
            }
        }
        
        let album = UIAlertAction(title: "Upload From Camera Roll", style: .default) { (_ alert: UIAlertAction) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(album)
        sheet.addAction(camera)
        self.present(sheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imgPhoto.image = chosenImage
        dismiss(animated:true, completion: nil)
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
