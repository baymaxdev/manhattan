//
//  StudentsViewController.swift
//  Manhattan
//
//  Created by gOd on 8/16/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StudentsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var users: [User] = []
    var userIds: [Int] = []
    var strTitle: String = ""
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        delegate = UIApplication.shared.delegate as? AppDelegate
        lbTitle.text = strTitle
        initialize()
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        delegate?.showLoader(vc: self)
        users.removeAll()
        let parameters = ["ids": userIds]
        Alamofire.request(BASE_URL + GETSOMEBYID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        self.users.append(User(user: element.dictionaryValue))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate?.user?.id == users[indexPath.row].id {
            delegate?.curUserId = (delegate?.user?.id)!
            delegate?.tabBarController?.selectedIndex = 4
        } else {
            delegate?.curUserId = users[indexPath.row].id!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMainViewController") as! ProfileMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
