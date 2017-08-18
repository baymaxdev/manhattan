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
import Stripe

class CourseViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource ,CourseCellDelegate ,STPAddCardViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AppDelegate?
    var courses: [Course] = []
    var payIndex: Int?
    
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
        if (course.paidUsers?.contains((delegate?.user?.id)!))! {
            cell.lbPrice.text = "Paid"
            cell.lbPrice.textColor = UIColor(red: 116/255.0, green: 221/255.0, blue: 137/255.0, alpha: 1.0)
        } else {
            cell.lbPrice.text = "$\((course.price)!)"
            cell.lbPrice.textColor = UIColor(red: 182/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        }
        cell.lbTitle.text = course.title
        cell.lbDescription.text = course.description
        cell.imgBack.sd_setImage(with: URL(string: (course.imgBack)!), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func didSelectDetail(_ index: Int) {
        if (courses[index].paidUsers?.contains((delegate?.user?.id)!))! {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
            vc.course = courses[index]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Setup add card view controller
            let action = UIAlertAction(title: "OK", style: .default, handler: { (ac: UIAlertAction) in
                self.payIndex = index
                let addCardViewController = STPAddCardViewController()
                addCardViewController.delegate = self
                
                // Present add card view controller
                //self.navigationController?.pushViewController(addCardViewController, animated: true)
                let nc = UINavigationController(rootViewController: addCardViewController)
                let titleDict = [NSForegroundColorAttributeName: UIColor.white]
                nc.navigationBar.titleTextAttributes = titleDict
                
                //addCardViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                //addCardViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                
                addCardViewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes(titleDict, for: .normal)
                addCardViewController.navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleDict, for: .normal)
                nc.navigationBar.tintColor = UIColor.white
                
                self.present(nc, animated: true)
            })
            delegate?.showAlert(vc: self, msg: "You should pay to see the content of this course", action: action)
        }
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(token)
        submitTokenToBackend(token, completion: { (error: Error?) in
            if let error = error {
                // Show error in add card view controller
                completion(error)
            }
            else {
                // Notify add card view controller that token creation was handled successfully
                completion(nil)
                
                // Dismiss add card view controller
                self.dismiss(animated: true)
            }
        })
    }
    
    func submitTokenToBackend(_ token: STPToken, completion: @escaping((_ error: Error?) -> Void) ) {
        delegate?.showLoader(vc: self)
        
        let thisvc = self
        let parameters = ["token": token.tokenId, "id": courses[payIndex!].id, "userId": delegate?.user?.id, "price": courses[payIndex!].price, "email" : delegate?.user?.email] as [String : Any]
        Alamofire.request(BASE_URL + COURSEPAY_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    self.initialize()
                    completion(nil)
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
            }
        }

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
