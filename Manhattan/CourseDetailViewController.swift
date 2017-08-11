//
//  CourseDetailViewController.swift
//  Manhattan
//
//  Created by gOd on 7/31/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import AVFoundation
import BMPlayer
import Alamofire
import SwiftyJSON

class CourseDetailViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vwPlayer: BMCustomPlayer!
    @IBOutlet weak var tableView: UITableView!
    
    var course: Course?
    var sectionIds: [Int] = []
    var sections: [String] = []
    var videos: [[Video]] = []
    var delegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        let asset = BMPlayerResource(url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
        self.vwPlayer.setVideo(resource: asset)
        self.vwPlayer.play()
        
        initialize()
        // Do any additional setup after loading the view.
    }
    
    func initialize() {
        delegate?.showLoader(vc: self)
        let parameters = ["id": course?.id]
        Alamofire.request(BASE_URL + COURSEGETALLVIDEOS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                if swiftyJsonVar["success"].boolValue == true {
                    let result = swiftyJsonVar["result"].arrayValue
                    for element in result {
                        let ele = element.dictionaryValue
                        self.sectionIds.append((ele["id"]?.intValue)!)
                        self.sections.append((ele["title"]?.stringValue)!)
                        let array = ele["videoInfo"]?.arrayValue
                        var v :[Video] = []
                        for element1 in array! {
                            v.append(Video(param: element1.dictionaryValue))
                        }
                        
                        self.videos.append(v)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (videos[section].count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailCell") as! CourseDetailCell
        cell.lbName.text = videos[indexPath.section][indexPath.row].title
        cell.lbDescription.text = videos[indexPath.section][indexPath.row].description
        cell.imgThumbnail.sd_setImage(with: URL(string: videos[indexPath.section][indexPath.row].thumbnail!), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func thumbnail(_ sourceURL:URL) -> UIImage {
        let asset = AVAsset(url: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return UIImage(named: "avatar")!
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
