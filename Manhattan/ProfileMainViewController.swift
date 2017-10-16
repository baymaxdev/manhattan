//
//  ProfileMainViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Alamofire
import SwiftyJSON
import SDWebImage

class ProfileMainViewController: MXSegmentedPagerController {

    @IBOutlet weak var lbMentor: UILabel!
    @IBOutlet weak var lbCourses: UILabel!
    @IBOutlet weak var lbStudents: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    var user: User?
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = APP_COLOR.cgColor
        btnJoin.layer.cornerRadius = btnJoin.frame.height / 2
        
        headerView.frame = CGRect(x: headerView.frame.origin.x, y: headerView.frame.origin.y, width: self.view.bounds.width, height: 180)
        segmentedPager.backgroundColor = .white
        
        // Parallax Header
        
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 200
        segmentedPager.parallaxHeader.minimumHeight = 200
        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = .white
        segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : APP_COLOR]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = APP_COLOR
        
        segmentedPager.pager.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
        delegate = UIApplication.shared.delegate as? AppDelegate
        initializeUser()
        initializeCourseCnt()
        if (delegate?.isMe())! {
            btnJoin.setTitle("Edit Profile", for: .normal)
            btnBack.isHidden = true
        } else {
            btnBack.isHidden = false
            if (delegate?.user?.mentors.contains((delegate?.curUserId)!))! {
                btnJoin.setTitle("Unfollow", for: .normal)
            } else {
                btnJoin.setTitle("Join", for: .normal)
            }
        }
    }
    
    func initializeUser() {
        if (delegate?.isMe())! {
            user = delegate?.user
            lbUsername.text = "@" + (user?.userName)!
            imgAvatar.sd_setImage(with: URL(string: (user?.photo)!), placeholderImage: UIImage(named: "avatar"))
            lbStudents.text = "\((user?.students.count)!)"
            lbMentor.text = "\((user?.mentors.count)!)"
        } else {
            self.delegate?.showLoader(vc: self)
            let parameters = ["id": delegate?.curUserId]
            Alamofire.request(BASE_URL + GETUSERBYID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.user = User(user: swiftyJsonVar["userInfo"].dictionaryValue)
                        self.lbUsername.text = "@" + (self.user?.userName)!
                        self.imgAvatar.sd_setImage(with: URL(string: (self.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
                        self.lbStudents.text = "\((self.user?.students.count)!)"
                        self.lbMentor.text = "\((self.user?.mentors.count)!)"
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
    
    func initializeCourseCnt() {
        let parameters = ["userId": delegate?.curUserId]
        Alamofire.request(BASE_URL + COURSEGETBYUSERID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    self.lbCourses.text = "\(result.count)"
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
        if (delegate?.isMe())! {
            user = delegate?.user
            lbUsername.text = "@" + (user?.userName)!
            imgAvatar.sd_setImage(with: URL(string: (user?.photo)!), placeholderImage: UIImage(named: "avatar"))
            lbStudents.text = "\((user?.students.count)!)"
            lbMentor.text = "\((user?.mentors.count)!)"
        }
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Feed", "Course", "Group", "About"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        
    }
    
    @IBAction func onJoin(_ sender: Any) {
        if (delegate?.isMe())! {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let parameters = ["me": (delegate?.user?.id)!, "him": (user?.id)!] as [String : Any]
            Alamofire.request(BASE_URL + FOLLOWUSER_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.delegate?.user = User(user: swiftyJsonVar["meObj"].dictionaryValue)
                        self.user = User(user: swiftyJsonVar["himObj"].dictionaryValue)
                        self.lbStudents.text = "\((self.user?.students.count)!)"
                        self.lbMentor.text = "\((self.user?.mentors.count)!)"
                        if (self.delegate?.user?.mentors.contains((self.user?.id)!))! {
                            self.btnJoin.setTitle("Unfollow", for: .normal)
                        } else {
                            self.btnJoin.setTitle("Join", for: .normal)
                        }
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

    @IBAction func onStudents(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentsViewController") as! StudentsViewController
        vc.userIds = (user?.students)!
        vc.strTitle = "Students"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onMentors(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentsViewController") as! StudentsViewController
        vc.userIds = (user?.mentors)!
        vc.strTitle = "Mentors"
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
