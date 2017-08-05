//
//  AddGroupViewController.swift
//  Manhattan
//
//  Created by gOd on 8/5/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField

class AddGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tfGroupName: JJMaterialTextfield!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.layer.cornerRadius = self.view.bounds.width * 0.4 / 2
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = UIColor(red: 0, green: 128.0/255.0, blue: 200/255.0, alpha: 1.0).cgColor
        
        tfGroupName.lineColor = UIColor(red: 0, green: 128.0/255.0, blue: 200/255.0, alpha: 1.0)
        tfGroupName.tintColor = UIColor(red: 0, green: 128.0/255.0, blue: 200/255.0, alpha: 1.0)
        tfGroupName.enableMaterialPlaceHolder = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onDone(_ sender: Any) {
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
