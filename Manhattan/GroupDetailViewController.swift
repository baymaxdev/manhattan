//
//  GroupDetailViewController.swift
//  Manhattan
//
//  Created by gOd on 8/15/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupDetailViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbGroupName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnJoin: UIButton!
    
    var group: Group?
    var users: [User] = []
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = UIApplication.shared.delegate as? AppDelegate
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        lbGroupName.text = group?.name
        initialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize() {
        self.delegate?.showLoader(vc: self)
        let parameters: [String: Any] = ["id": group?.id]
        
        Alamofire.request(BASE_URL + GROUPGETBYID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    self.users.removeAll()
                    let result = swiftyJsonVar["result"].dictionaryValue
                    let arr = result["userInfo"]?.arrayValue
                    let u = result["users"]?.arrayValue
                    for element in u! {
                        self.users.append(User(user: (arr?[element.intValue].dictionaryValue)!))
                    }
                    if (self.group?.userIds?.contains((self.delegate?.user?.id)!))! {
                        self.btnJoin.setTitle("Leave this Group", for: .normal)
                    } else {
                        self.btnJoin.setTitle("Join this Group", for: .normal)
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
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onJoin(_ sender: Any) {
        self.delegate?.showLoader(vc: self)
        let parameters: [String: Any] = ["id": group?.id, "userId": delegate?.user?.id]
        
        Alamofire.request(BASE_URL + GROUPUPDATE_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let action = UIAlertAction(title: "OK", style: .default) { action in
                        let res = swiftyJsonVar["result"].dictionaryValue
                        self.group = Group(param: res)
                        self.initialize()
                    }
                    var msg = ""
                    if (self.group?.userIds?.contains((self.delegate?.user?.id)!))! {
                        msg = "Left the group successfully"
                    } else {
                        msg = "Joined the group successfully"
                    }
                    self.delegate?.showAlert(vc: self, msg: msg, action: action)
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
                
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let user = users[indexPath.row]
        cell.lbOne.text = user.userName
        cell.lbTwo.text = user.name
        cell.imgAvatar.sd_setImage(with: URL(string: user.photo!), placeholderImage: UIImage(named: "avatar"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if delegate?.user?.id == group?.userIds?[index] {
            delegate?.curUserId = (delegate?.user?.id)!
            delegate?.tabBarController?.selectedIndex = 4
        } else {
            delegate?.curUserId = (group?.userIds?[index])!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMainViewController") as! ProfileMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
