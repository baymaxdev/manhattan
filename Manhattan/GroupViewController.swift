//
//  GroupViewController.swift
//  Manhattan
//
//  Created by gOd on 8/2/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddGroup: UIButton!
    
    var delegate: AppDelegate?
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnAddGroup.layer.cornerRadius = btnAddGroup.frame.height / 2
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        tableView.tableFooterView = customView
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        // Do any additional setup after loading the view.
    }

    func initialize() {
        delegate?.showLoader(vc: self)
        groups.removeAll()
        let parameters = ["userId": delegate?.curUserId]
        Alamofire.request(BASE_URL + GROUPGETBYUSERID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        self.groups.append(Group(param: element.dictionaryValue))
                    }
                    self.tableView.reloadData()
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let group = groups[indexPath.row]
        cell.lbOne.text = group.name
        cell.lbTwo.text = "\((group.userIds?.count)!) members"
        cell.imgAvatar.sd_setImage(with: URL(string: group.photo!), placeholderImage: UIImage(named: "avatar"))
        // Configure the cell...
        
        return cell
    }
    
    @IBAction func onAddGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupViewController")
        self.navigationController?.pushViewController(vc, animated: true)
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
