//
//  Signup4thViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import THCalendarDatePicker
import Alamofire
import SwiftyJSON
import AWSS3

class Signup4thViewController: UIViewController ,THDatePickerDelegate{

    @IBOutlet weak var tagList: AHTagsLabel!
    @IBOutlet weak var vwTag: UIView!
    @IBOutlet weak var btnDoB: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var vwDoB: UIView!
    @IBOutlet weak var btnPrev: UIButton!
    
    var image: UIImage?
    var delegate: AppDelegate?
    let transferUtility = AWSS3TransferUtility.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        var tags : [AHTag] = []
        
        for str in strInterests {
            let tag = AHTag(category: "", title: str, color: APP_COLOR, enabled: false)
            tags.append(tag)
        }
        
        tagList.setTags(tags)
        
        vwTag.layer.cornerRadius = 10
        vwDoB.layer.cornerRadius = 10
        
        btnSignup.layer.cornerRadius = btnSignup.frame.height / 2
        btnSignup.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnSignup.layer.borderWidth = 0
        
        btnPrev.layer.cornerRadius = btnPrev.frame.height / 2
        btnPrev.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnPrev.layer.borderWidth = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

    @IBAction func onDoB(_ sender: Any) {
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
        formatter.dateFormat = "MM/dd/yyyy"
        btnDoB.setTitle(formatter.string(from: datePicker.date), for: .normal)
        datePicker.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        datePicker.dismissSemiModalView()
    }
    
    @IBAction func onSignup(_ sender: Any) {
        if btnDoB.titleLabel?.text == "__/__/____" {
            delegate?.showAlert(vc: self, msg: "Date of Birth field is required", action: nil)
        }
        else {
            var tagStr : [String] = []
            for tag in tagList.tags! {
                if tag.enabled == true {
                    tagStr.append(tag.title)
                }
            }
            delegate?.user?.interests = tagStr
            delegate?.user?.dob = btnDoB.titleLabel?.text
            
            var parameters = (delegate?.user?.getUser())!
            delegate?.showLoader(vc: self)
            
            let data = UIImagePNGRepresentation(image!)
            let filename = delegate?.getFileName(type: "user")
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
                            parameters["photo"] = "https://s3.us-east-2.amazonaws.com/dariya-manhattan/\(filename!)"
                            
                            Alamofire.request(BASE_URL + SIGNUP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                                
                                if((resData.result.value) != nil) {
                                    let swiftyJsonVar = JSON(resData.result.value!)
                                    
                                    if swiftyJsonVar["success"].boolValue == true {
                                        FUser.registerUser(withName: (self.delegate?.user?.name)!, email: (self.delegate?.user?.email)!, password: (self.delegate?.user?.password)!, profilePic: (self.delegate?.user?.photo)!) { (status, err) in
                                            DispatchQueue.main.async {
                                                if status == true {
                                                    
                                                    FUser.loginUser(withEmail: (self.delegate?.user?.email)!, password: (self.delegate?.user?.password)!) { (status, err) in
                                                        DispatchQueue.main.async {
                                                            self.delegate?.hideLoader()
                                                            if status == true {
                                                                let action = UIAlertAction(title: "OK", style: .default){ action in
                                                                    let userObj = swiftyJsonVar["userObj"].dictionaryValue
                                                                    self.delegate?.user = User()
                                                                    self.delegate?.user?.setUser(userObj)
                                                                    self.delegate?.configureTabBar()
                                                                }
                                                                self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
                                                                return
                                                            } else {
                                                                self.delegate?.showAlert(vc: self, msg: err, action: nil)
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    self.delegate?.hideLoader()
                                                    self.delegate?.showAlert(vc: self, msg: err, action: nil)
                                                }
                                            }
                                        }
                                    } else {
                                        self.delegate?.hideLoader()
                                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                                    }
                                    
                                } else {
                                    self.delegate?.hideLoader()
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
