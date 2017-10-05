//
//  VideoPostViewController.swift
//  Manhattan
//
//  Created by gOd on 7/28/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import BMPlayer
import Alamofire
import SwiftyJSON
import AWSS3

class VideoPostViewController: UIViewController {
    
    @IBOutlet weak var vwPlayer: BMCustomPlayer!
    @IBOutlet weak var tfDescription: FloatLabelTextField!
    
    var delegate: AppDelegate?
    var isRecord: Bool?
    var videoUrl: URL?
    let transferUtility = AWSS3TransferUtility.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .none
        let asset = BMPlayerResource(url: videoUrl!)
        vwPlayer.setVideo(resource: asset)
        vwPlayer.play()

        
        /*vwPlayer.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            //let _ = self.navigationController?.popViewController(animated: true)
        }*/
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onDone(_ sender: Any) {
        if (tfDescription.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Description field is required.", action: nil)
        }
        else {
            delegate?.showLoader(vc: self)
            
            var data: Data?
            do {
                data = try Data.init(contentsOf: videoUrl!)
            }
            catch {
                
            }

            let filename = delegate?.getFileName(type: "video")
            transferUtility.uploadData(
                data!,
                bucket: S3BUCKETNAME,
                key: filename!,
                contentType: "video/mp4",
                expression: nil,
                completionHandler: { (task, error) -> Void in
                    DispatchQueue.main.async(execute: {
                        if let error = error {
                            self.delegate?.hideLoader()
                            self.delegate?.showAlert(vc: self, msg: "Failed with error: \(error)", action: nil)
                        }
                        else{
                            let parameters = ["userId": self.delegate?.user?.id, "type": "V", "postTitle": self.tfDescription.text, "postContent": "https://s3.us-east-2.amazonaws.com/dariya-manhattan/\(filename!)"] as [String : Any]
                            
                            Alamofire.request(BASE_URL + POST_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
                                self.delegate?.hideLoader()
                                
                                if((resData.result.value) != nil) {
                                    let swiftyJsonVar = JSON(resData.result.value!)
                                    
                                    if swiftyJsonVar["success"].boolValue == true {
                                        let action = UIAlertAction(title: "OK", style: .default){ action in
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
                                    }
                                    else {
                                        self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                                    }
                                    
                                } else {
                                    self.delegate?.showAlert(vc: self, msg: "Sorry, Failed to connect to server.", action: nil)
                                }
                            }
                        }
                    })
            }).continueWith { (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    print("Upload Starting!")
                    // Do something with uploadTask.
                }
                
                return nil;
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
