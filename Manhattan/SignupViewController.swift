//
//  SignupViewController.swift
//  Manhattan
//
//  Created by gOd on 7/21/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import THCalendarDatePicker

class SignupViewController: UIViewController ,THDatePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var btnDoB: UIButton!
    @IBOutlet weak var tfFirstName: JJMaterialTextfield!
    @IBOutlet weak var tfLastName: JJMaterialTextfield!
    @IBOutlet weak var tfEmail: JJMaterialTextfield!
    @IBOutlet weak var tfPassword: JJMaterialTextfield!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tagList: AHTagsLabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tagView: UIView!
    
    let strInterests = ["Economy", "Military", "Culture", "Technology", "Politics", "Healthcare", "Entertainment", "Sports", "Arts", "Film", "Video", "Economy", "Military", "Culture", "Technology", "Politics", "Healthcare", "Entertainment", "Sports", "Arts", "Film", "Video"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
        
        datePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize() {
        tfFirstName.enableMaterialPlaceHolder = true
        tfLastName.enableMaterialPlaceHolder = true
        tfEmail.enableMaterialPlaceHolder = true
        tfPassword.enableMaterialPlaceHolder = true
        
        btnSignup.layer.cornerRadius = btnSignup.frame.height / 2
        
        imgAvatar.layer.borderWidth = 5
        imgAvatar.layer.borderColor = UIColor(red: 152/255.0, green: 200/255.0, blue: 223/255.0, alpha: 1.0).cgColor
        imgAvatar.layer.cornerRadius = self.view.bounds.width * 0.4 / 2
        
        var tags : [AHTag] = []
        
        for str in strInterests {
            let tag = AHTag(category: "", title: str, color: UIColor(red: 116/255.0, green: 221/255.0, blue: 137/255.0, alpha: 1.0), enabled: false)
            tags.append(tag)
        }

        tagList.setTags(tags)
        tagView.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var contentRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        for view in self.contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        print(tagView.frame.height)
        print(contentRect.size.height)
        heightConstraint.constant = contentRect.size.height + 30
    }
    
    lazy var datePicker:THDatePickerViewController = {
        let dp = THDatePickerViewController.datePicker()
        dp?.delegate = self
        dp?.setAllowClearDate(false)
        dp?.setClearAsToday(true)
        dp?.setAutoCloseOnSelectDate(false)
        dp?.setAllowSelectionOfSelectedDate(true)
        dp?.setDisableHistorySelection(false)
        dp?.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp?.selectedBackgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 200/255.0, alpha: 1.0)
        dp?.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp?.currentDateColorSelected = UIColor.white
        return dp!
    }()
    
    @IBAction func onbtnDoB(_ sender: Any) {
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
        btnDoB.titleLabel?.text = formatter.string(from: datePicker.date)
        datePicker.dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        datePicker.dismissSemiModalView()
    }

    @IBAction func onBtnSignup(_ sender: Any) {
    }
    
    @IBAction func onBack(_ sender: Any) {
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
