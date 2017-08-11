//
//  AboutViewController.swift
//  Manhattan
//
//  Created by gOd on 8/5/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AboutViewController: UITableViewController {

    @IBOutlet weak var lbEducationPeriod: UILabel!
    @IBOutlet weak var lbEducation: UILabel!
    @IBOutlet weak var lbSkills: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAbout: UILabel!
    
    var user: User?
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        initializeUser()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 44
    }
    
    func initializeUser() {
        if (delegate?.isMe())! {
            user = delegate?.user
            lbName.text = user?.name
            lbAbout.text = user?.bio
            lbSkills.text = user?.skill
            lbEducation.text = user?.education
            lbEducationPeriod.text = "\((user?.eduFrom)!) - \((user?.eduTo)!)"
        } else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["id": delegate?.curUserId]
            Alamofire.request(BASE_URL + GETUSERBYID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.user = User(user: swiftyJsonVar["userInfo"].dictionaryValue)
                        self.lbName.text = self.user?.name
                        self.lbAbout.text = self.user?.bio
                        self.lbSkills.text = self.user?.skill
                        self.lbEducation.text = self.user?.education
                        self.lbEducationPeriod.text = "\((self.user?.eduFrom)!) - \((self.user?.eduTo)!)"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (delegate?.isMe())! {
            user = delegate?.user
            lbName.text = user?.name
            lbAbout.text = user?.bio
            lbSkills.text = user?.skill
            lbEducation.text = user?.education
            lbEducationPeriod.text = "\((user?.eduFrom)!) - \((user?.eduTo)!)"
        }
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
