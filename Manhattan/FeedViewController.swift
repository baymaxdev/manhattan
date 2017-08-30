//
//  FeedViewController.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import ExpandableLabel
import Alamofire
import SwiftyJSON
import BMPlayer

var navController : UINavigationController?

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , ExpandableLabelDelegate, VideoCellDelegate, PhotoCellDelegate, BlogCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    var delegate: AppDelegate?
    var expandableStates : Array<Bool>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        
        navController = self.navigationController
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        delegate?.showLoader(vc: self)
        posts.removeAll()
        Alamofire.request(BASE_URL + POSTGETALL_URL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        self.posts.append(Post(param: element.dictionaryValue))
                    }
                    self.expandableStates = [Bool](repeating: true, count: self.posts.count)
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if post.type == .blog {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
            cell.lbBlogContent.delegate = self
            cell.lbBlogContent.text = post.postContent
            cell.lbBlogTitle.text = post.postTitle
            cell.lbBlogContent.collapsed = expandableStates[indexPath.row]
            cell.lbTitle.text = "\((post.user?.name)!) posted an article."
            cell.lbDate.text = dateFromISOString(string: post.createdTime!)
            cell.lbLikeCnt.text = "\((post.likes?.count)!) Likes"
            cell.lbCommentCnt.text = "\((post.comments?.count)!) Comments"
            cell.imgAvatar.sd_setImage(with: URL(string: (post.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
            if (post.likes?.contains((self.delegate?.user?.id)!) == true) {
                cell.btnLike.isSelected = true
            }
            else {
                cell.btnLike.isSelected = false
            }
            cell.index = indexPath.row
            cell.delegate = self
            cell.initCell()
            return cell
        } else if post.type == .photo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            cell.index = indexPath.row
            cell.imgAvatar.sd_setImage(with: URL(string: (post.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
            cell.imgPhoto.sd_setImage(with: URL(string: post.postContent!), placeholderImage: UIImage(named: "placeholder"))
            cell.lbDescription.text = post.postTitle
            cell.lbTitle.text = "\((post.user?.name)!) posted a photo."
            cell.delegate = self
            cell.lbDate.text = dateFromISOString(string: post.createdTime!)
            cell.lbLikeCnt.text = "\((post.likes?.count)!) Likes"
            cell.lbCommentCnt.text = "\((post.comments?.count)!) Comments"
            if (post.likes?.contains((self.delegate?.user?.id)!) == true) {
                cell.btnLike.isSelected = true
            }
            else {
                cell.btnLike.isSelected = false
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            let asset = BMPlayerResource(url: URL(string: post.postContent!)!)
            cell.vwPlayer.setVideo(resource: asset)
            cell.vwPlayer.pause()
            cell.index = indexPath.row
            cell.lbDescription.text = post.postTitle
            cell.lbTitle.text = "\((post.user?.name)!) posted a video."
            cell.delegate = self
            cell.lbDate.text = dateFromISOString(string: post.createdTime!)
            cell.lbLikeCnt.text = "\((post.likes?.count)!) Likes"
            cell.lbCommentCnt.text = "\((post.comments?.count)!) Comments"
            cell.imgAvatar.sd_setImage(with: URL(string: (post.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
            if (post.likes?.contains((self.delegate?.user?.id)!) == true) {
                cell.btnLike.isSelected = true
            }
            else {
                cell.btnLike.isSelected = false
            }
            return cell
        }
    }
    
    func dateFromISOString(string: String) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: string)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM yyyy h:mm a"
        return dateFormatter1.string(from: date!)
        
    }
    // Expandable Label Delegate
    
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            expandableStates[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            expandableStates[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool {
        return true
    }
    
    // Cell Delegates
    
    func didSelectComment(_ index: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.post = posts[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectProfile(_ index: Int) {
        if delegate?.user?.id == posts[index].user?.id {
            delegate?.curUserId = (delegate?.user?.id)!
            delegate?.tabBarController?.selectedIndex = 4
        } else {
            delegate?.curUserId = (posts[index].user?.id)!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMainViewController") as! ProfileMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectLike(_ index: Int) {
        let parameters = ["id": posts[index].id, "userId": delegate?.user?.id]
        Alamofire.request(BASE_URL + LIKE_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let flag = swiftyJsonVar["index"].intValue
                    if (flag == -1) {
                        self.posts[index].likes?.append((self.delegate?.user?.id)!)
                    } else {
                        self.posts[index].likes = self.posts[index].likes?.filter { $0 != self.delegate?.user?.id }
                    }
                    
                    if (self.posts[index].type == .blog) {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BlogCell
                        cell.lbLikeCnt.text = "\((self.posts[index].likes?.count)!) Likes"
                    } else if (self.posts[index].type == .photo) {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PhotoCell
                        cell.lbLikeCnt.text = "\((self.posts[index].likes?.count)!) Likes"
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! VideoCell
                        cell.lbLikeCnt.text = "\((self.posts[index].likes?.count)!) Likes"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
