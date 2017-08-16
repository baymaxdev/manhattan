//
//  CourseViewController.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CourseViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource ,CourseCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AppDelegate?
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 272
        tableView.register(UINib(nibName: "CourseCell", bundle: nil), forCellReuseIdentifier: "CourseCell")
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        // Do any additional setup after loading the view.
    }

    func initialize() {
        delegate?.showLoader(vc: self)
        courses.removeAll()
        Alamofire.request(BASE_URL + COURSEGETALL_URL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
