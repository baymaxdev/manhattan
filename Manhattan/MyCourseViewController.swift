//
//  MyCourseViewController.swift
//  Manhattan
//
//  Created by gOd on 8/2/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyCourseViewController: UITableViewController ,CourseCellDelegate {

    var user: User?
    var delegate: AppDelegate?
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 272
        tableView.register(UINib(nibName: "CourseCell", bundle: nil), forCellReuseIdentifier: "CourseCell")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        tableView.tableFooterView = customView
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        initializeUser()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
                }
            }
        }
    }

    func initialize() {
        delegate?.showLoader(vc: self)
        courses.removeAll()
        let parameters = ["userId": user?.id]
        Alamofire.request(BASE_URL + COURSEGETBYUSERID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        self.courses.append(Course(param: element.dictionaryValue))
                    }
                    
                    self.tableView.reloadData()
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
                
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialize()
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
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseCell
        let course = courses[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.lbName.text = course.user?.name
        cell.lbPrice.text = "$\((course.price)!)"
        cell.lbTitle.text = course.title
        cell.lbDescription.text = course.description
        cell.imgBack.sd_setImage(with: URL(string: (course.imgBack)!), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func didSelectDetail(_ index: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
        vc.course = courses[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectProfile(_ index: Int) {
        if delegate?.user?.id == courses[index].user?.id {
            delegate?.curUserId = (delegate?.user?.id)!
            delegate?.tabBarController?.selectedIndex = 4
        } else {
            delegate?.curUserId = (courses[index].user?.id)!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMainViewController") as! ProfileMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
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
