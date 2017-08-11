//
//  CommentViewController.swift
//  Manhattan
//
//  Created by gOd on 7/30/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import ExpandableLabel
import Alamofire
import SwiftyJSON

class CommentViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, VideoCellDelegate, PhotoCellDelegate, BlogCellDelegate{

    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var vwComment: UIView!
    @IBOutlet weak var tvComment: FloatLabelTextView!
    @IBOutlet weak var tableView: UITableView!
    
    var post: Post?
    var comments: [Comment] = []
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        
        vwComment.layer.borderWidth = 1
        vwComment.layer.borderColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).cgColor
        //tvComment.layer.cornerRadius = 10
        //tvComment.layer.borderWidth = 1
        //tvComment.layer.borderColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 200/255.0, alpha: 1.0).cgColor
        btnPost.layer.cornerRadius = 10
        delegate = UIApplication.shared.delegate as? AppDelegate
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        delegate?.showLoader(vc: self)
        comments.removeAll()
        let parameters = ["postId": post?.id]
        Alamofire.request(BASE_URL + GETCOMMENTBYPOSTID_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        self.comments.append(Comment(param: element.dictionaryValue))
                    }
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.comments.count, section: 0), at: .bottom, animated: true)
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
                
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
            }
        }
        tvComment.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(_ sender: Any) {
        if tvComment.text.isEmpty {
            delegate?.showAlert(vc: self, msg: "Comment field is required", action: nil)
        } else {
            delegate?.showLoader(vc: self)
            let parameters = ["postId": post?.id, "userId": delegate?.user?.id, "content": tvComment.text] as [String : Any]
            Alamofire.request(BASE_URL + COMMENTPOST_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                self.delegate?.hideLoader()
                
                if((resData.result.value) != nil) {
                    let swiftyJsonVar = JSON(resData.result.value!)
                    if swiftyJsonVar["success"].boolValue == true {
                        self.initialize()
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

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if post?.type == .blog {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
                cell.lbBlogContent.text = post?.postContent
                cell.lbBlogTitle.text = post?.postTitle
                cell.lbBlogContent.collapsed = false
                cell.lbTitle.text = "\((post?.user?.name)!) posted an article."
                cell.lbDate.text = dateFromISOString(string: (post?.createdTime)!)
                cell.lbLikeCnt.text = "\((post?.likes?.count)!) Likes"
                cell.lbCommentCnt.text = "\(comments.count) Comments"
                cell.imgAvatar.sd_setImage(with: URL(string: (post?.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
                if (post?.likes?.contains((self.delegate?.user?.id)!) == true) {
                    cell.btnLike.isSelected = true
                }
                else {
                    cell.btnLike.isSelected = false
                }
                cell.index = indexPath.row
                cell.delegate = self
                cell.initCell()
                return cell
            } else if post?.type == .photo {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
                cell.index = indexPath.row
                cell.lbDescription.text = post?.postTitle
                cell.lbTitle.text = "\((post?.user?.name)!) posted an photo."
                cell.delegate = self
                cell.lbDate.text = dateFromISOString(string: (post?.createdTime)!)
                cell.lbLikeCnt.text = "\((post?.likes?.count)!) Likes"
                cell.lbCommentCnt.text = "\(comments.count) Comments"
                cell.imgAvatar.sd_setImage(with: URL(string: (post?.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
                cell.imgPhoto.sd_setImage(with: URL(string: (post?.postContent)!), placeholderImage: UIImage(named: "placeholder"))
                if (post?.likes?.contains((self.delegate?.user?.id)!) == true) {
                    cell.btnLike.isSelected = true
                }
                else {
                    cell.btnLike.isSelected = false
                }

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
                cell.index = indexPath.row
                cell.lbDescription.text = post?.postTitle
                cell.lbTitle.text = "\((post?.user?.name)!) posted an video."
                cell.delegate = self
                cell.lbDate.text = dateFromISOString(string: (post?.createdTime)!)
                cell.lbLikeCnt.text = "\((post?.likes?.count)!) Likes"
                cell.lbCommentCnt.text = "\(comments.count) Comments"
                cell.imgAvatar.sd_setImage(with: URL(string: (post?.user?.photo)!), placeholderImage: UIImage(named: "avatar"))
                if (post?.likes?.contains((self.delegate?.user?.id)!) == true) {
                    cell.btnLike.isSelected = true
                }
                else {
                    cell.btnLike.isSelected = false
                }
                
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.lbName.text = comments[indexPath.row - 1].user?.name
            cell.lbComment.text = comments[indexPath.row - 1].content
            cell.index = indexPath.row - 1
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
    
    // Cell Delegates
    
    func didSelectComment(_ index: Int) {

    }
    
    func didSelectProfile(_ index: Int) {
        
    }
    
    func didSelectLike(_ index: Int) {
        let parameters = ["id": post?.id, "userId": delegate?.user?.id]
        Alamofire.request(BASE_URL + LIKE_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let flag = swiftyJsonVar["index"].intValue
                    if (flag == -1) {
                        self.post?.likes?.append((self.delegate?.user?.id)!)
                    } else {
                        self.post?.likes = self.post?.likes?.filter { $0 != self.delegate?.user?.id }
                    }
                    
                    if (self.post?.type == .blog) {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BlogCell
                        cell.lbLikeCnt.text = "\((self.post?.likes?.count)!) Likes"
                    } else if (self.post?.type == .photo) {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PhotoCell
                        cell.lbLikeCnt.text = "\((self.post?.likes?.count)!) Likes"
                    } else {
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! VideoCell
                        cell.lbLikeCnt.text = "\((self.post?.likes?.count)!) Likes"
                    }
                }
                else {
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                }
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
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
