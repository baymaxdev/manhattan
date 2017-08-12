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

class Signup4thViewController: UIViewController ,THDatePickerDelegate{

    @IBOutlet weak var tagList: AHTagsLabel!
    @IBOutlet weak var vwTag: UIView!
    @IBOutlet weak var btnDoB: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var vwDoB: UIView!
    @IBOutlet weak var btnPrev: UIButton!
    
    var image: UIImage?
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        var tags : [AHTag] = []
        
        for str in strInterests {
            let tag = AHTag(category: "", title: str, color: UIColor(red: 116/255.0, green: 221/255.0, blue: 137/255.0, alpha: 1.0), enabled: false)
            tags.append(tag)
        }
        
        tagList.setTags(tags)
        vwTag.layer.cornerRadius = 10
        vwDoB.layer.cornerRadius = 10
        
        btnSignup.layer.cornerRadius = btnSignup.frame.height / 2
        btnSignup.layer.borderColor = UIColor(red: 64/255.0, green: 224/255.0, blue: 128/255.0, alpha: 1.0).cgColor
        btnSignup.layer.borderWidth = 1
        
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
        formatter.dateFormat = "dd/MM/yyyy"
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
            
            let parameters = (delegate?.user?.getUser())!
            delegate?.showLoader(vc: self)
            
            Alamofire.request(BASE_URL + SIGNUP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    
                    if swiftyJsonVar["success"].boolValue == true {
                        let action = UIAlertAction(title: "OK", style: .default){ action in
                            let userObj = swiftyJsonVar["userObj"].dictionaryValue
                            self.delegate?.user?.id = userObj["id"]?.intValue
                            self.delegate?.configureTabBar()
                        }
                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
                        return
                    }
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                    
                } else {
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
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
