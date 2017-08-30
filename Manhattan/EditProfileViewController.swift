//
//  EditProfileViewController.swift
//  Manhattan
//
//  Created by gOd on 8/5/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import THCalendarDatePicker
import Alamofire
import SwiftyJSON
import AWSS3

class EditProfileViewController: UITableViewController ,THDatePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tvBio: FloatLabelTextView!
    @IBOutlet weak var tagList: AHTagsLabel!
    @IBOutlet weak var vwTag: UIView!
    @IBOutlet weak var tfTo: JJMaterialTextfield!
    @IBOutlet weak var tfFrom: JJMaterialTextfield!
    @IBOutlet weak var tvEducation: FloatLabelTextView!
    @IBOutlet weak var tvSkill: FloatLabelTextView!
    @IBOutlet weak var lbDob: UILabel!
    @IBOutlet weak var tfPassword: JJMaterialTextfield!
    @IBOutlet weak var tfEmail: JJMaterialTextfield!
    @IBOutlet weak var tfUsername: JJMaterialTextfield!
    @IBOutlet weak var tfName: JJMaterialTextfield!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var user: User?
    var delegate: AppDelegate?
    var isPhotoSelected = false
    let transferUtility = AWSS3TransferUtility.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        var tags : [AHTag] = []
        
        for str in strInterests {
            var tag = AHTag(category: "", title: str, color: UIColor(red: 116/255.0, green: 221/255.0, blue: 137/255.0, alpha: 1.0), enabled: false)
            if (user?.interests.contains(str))! {
                tag.enabled = true
            }
            tags.append(tag)
        }
        
        tagList.setTags(tags)
        vwTag.layer.cornerRadius = 10
        
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = APP_COLOR.cgColor
        imgAvatar.layer.cornerRadius = self.view.bounds.width * 0.4 / 2
        
        tfTo.lineColor = APP_COLOR
        tfFrom.lineColor = APP_COLOR
        tfName.lineColor = APP_COLOR
        tfEmail.lineColor = APP_COLOR
        tfPassword.lineColor = APP_COLOR
        tfUsername.lineColor = APP_COLOR
        
        imgAvatar.sd_setImage(with: URL(string: (user?.photo)!), placeholderImage: UIImage(named: "avatar"))
        tfName.text = user?.name
        tfUsername.text = user?.userName
        tfEmail.text = user?.email
        if (user?.isFB)! {
            tfPassword.isEnabled = false
            tfEmail.isEnabled = false
            tfPassword.text = ""
        } else {
            tfPassword.text = user?.password
        }
        lbDob.text = user?.dob
        tvSkill.text = user?.skill
        tvEducation.text = user?.education
        tfFrom.text = user?.eduFrom
        tfTo.text = user?.eduTo
        tvBio.text = user?.bio
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        var tagStr : [String] = []
        for tag in tagList.tags! {
            if tag.enabled == true {
                tagStr.append(tag.title)
            }
        }
        
        if (tfName.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Name field is required", action: nil)
        } else if (tfUsername.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Username field is required", action: nil)
        } else if (tfEmail.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Email field is required", action: nil)
        } else if (user?.isFB == false) {
            if (tfPassword.text?.isEmpty)! {
                delegate?.showAlert(vc: self, msg: "Password field is required", action: nil)
            } else if (tfPassword.text?.characters.count)! < 6 {
                delegate?.showAlert(vc: self, msg: "Password must include at least 6 characters", action: nil)
            } else {
        
                delegate?.showLoader(vc: self)
            
                let data = UIImagePNGRepresentation(imgAvatar.image!)
            
                var filename = user?.photo
                if (filename?.isEmpty)! {
                    filename = delegate?.getFileName(type: "user")
                } else {
                    let index = filename?.index((filename?.startIndex)!, offsetBy: 52)
                    filename = filename?.substring(from: index!)
                }
            
                print(filename!)
            
                transferUtility.uploadData(
                    data!,
                    bucket: S3BUCKETNAME,
                    key: filename!,
                    contentType: "image/jpg",
                    expression: nil,
                    completionHandler: { (task, error) -> Void in
                        DispatchQueue.main.async(execute: {
                            if let error = error {
                                self.delegate?.hideLoader()
                                self.delegate?.showAlert(vc: self, msg: "Failed with error: \(error)", action: nil)
                            }
                            else{
                                self.user?.photo = "https://s3.us-east-2.amazonaws.com/dariya-manhattan/\(filename!)"
                                let parameters = ["id": (self.user?.id)!, "email": self.tfEmail.text!, "password": self.tfPassword.text!, "name": self.tfName.text!, "userName": self.tfUsername.text!, "dob": self.lbDob.text!, "photo": (self.user?.photo)!, "interests": tagStr, "skill": self.tvSkill.text!, "education": self.tvEducation.text!, "eduFrom": self.tfFrom.text!, "eduTo": self.tfTo.text!, "bio": self.tvBio.text!] as [String : Any]
                                Alamofire.request(BASE_URL + UPDATEUSER_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                                
                                    if((resData.result.value) != nil) {
                                        let swiftyJsonVar = JSON(resData.result.value!)
                                    
                                        if swiftyJsonVar["success"].boolValue == true {
                                            FUser.updateProfile(name: self.tfName.text!, email: self.tfEmail.text!, password: self.tfPassword.text!, profilePic: (self.user?.photo)!, completion: { (status, err) in
                                                DispatchQueue.main.async {
                                                    self.delegate?.hideLoader()
                                                    if status == true {
                                                        let action = UIAlertAction(title: "OK", style: .default) { action in
                                                            let userObj = swiftyJsonVar["userObj"].dictionaryValue
                                                            self.delegate?.user = User(user: userObj)
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
                                                        return
                                                    } else {
                                                        self.delegate?.showAlert(vc: self, msg: err, action: nil)
                                                    }
                                                }
                                            })
                                        } else {
                                            self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                                        }
                                    
                                    } else {
                                        self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
                                    }
                                }
                            
                            }
                        })
                }).continueWith { (task) -> AnyObject! in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                    }
                
                    if let _ = task.result {
                        print("Upload Starting!")
                        // Do something with uploadTask.
                    }
                
                    return nil;
                }
            }
        }
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
        isPhotoSelected = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // Date picker
    lazy var datePicker:THDatePickerViewController = {
        let dp = THDatePickerViewController.datePicker()
        dp?.delegate = self
        dp?.setAllowClearDate(false)
        dp?.setClearAsToday(true)
        dp?.setAutoCloseOnSelectDate(false)
        dp?.setAllowSelectionOfSelectedDate(true)
        dp?.setDisableHistorySelection(false)
        dp?.setDisableFutureSelection(true)
        //dp.autoCloseCancelDelay = 5.0
        dp?.selectedBackgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 200/255.0, alpha: 1.0)
        dp?.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp?.currentDateColorSelected = UIColor.white
        return dp!
    }()
    
    @IBAction func onDob(_ sender: Any) {
        let curDate = Date()
        datePicker.date = curDate
        
        datePicker.setDateHasItemsCallback { (date: Date!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        }
        presentSemiViewController(datePicker, withOptions: [
            KNSemiModalOptionKeys.pushParentBack.takeRetainedValue()    : NSNumber(value: false),
            KNSemiModalOptionKeys.animationDuration.takeRetainedValue() : NSNumber(value: 0.3),
            KNSemiModalOptionKeys.shadowOpacity.takeRetainedValue()     : NSNumber(value: 0.3)
            ])
    }
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        lbDob.text = formatter.string(from: datePicker.date)
        datePicker.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        datePicker.dismissSemiModalView()
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
