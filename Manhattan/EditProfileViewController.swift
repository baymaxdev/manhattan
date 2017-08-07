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
    
    let strInterests = ["Economy", "Military", "Culture", "Technology", "Politics", "Healthcare", "Entertainment", "Sports", "Arts", "Film", "Video", "Economy", "Military", "Culture", "Technology", "Politics", "Healthcare", "Entertainment", "Sports", "Arts", "Film", "Video"]
    let selectedInterests = ["Economy", "Technology", "Sports"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var tags : [AHTag] = []
        
        for str in strInterests {
            var tag = AHTag(category: "", title: str, color: UIColor(red: 116/255.0, green: 221/255.0, blue: 137/255.0, alpha: 1.0), enabled: false)
            if selectedInterests.contains(str) {
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
        
        tfName.text = "Dariya Khojasteh"
        tfUsername.text = "dariya"
        tfEmail.text = "dariya@gmail.com"
        tfPassword.text = "abcd"
        tvSkill.text = "iOS, Android, React Native, Xamarin, Node.js, AngularJS"
        tvEducation.text = "Stanford University"
        tfFrom.text = "2007"
        tfTo.text = "2011"
        tvBio.text = "I am Dariya Khojasteh from US. I have graduated Stanford University."
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
