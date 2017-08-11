//
//  BlogPostViewController.swift
//  Manhattan
//
//  Created by gOd on 7/28/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BlogPostViewController: UIViewController {

    @IBOutlet weak var tvBlog: FloatLabelTextView!
    @IBOutlet weak var tfPostHeader: FloatLabelTextField!
    
    var delegate: AppDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(_ sender: Any) {
        if (tfPostHeader.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Header field is required.", action: nil)
        } else if (tvBlog.text.isEmpty) {
            delegate?.showAlert(vc: self, msg: "Blog field is required.", action: nil)
        } else {
            let parameters = ["userId": delegate?.user?.id, "type": "B", "postTitle": tfPostHeader.text, "postContent": tvBlog.text] as [String : Any]
            
            delegate?.showLoader(vc: self)
            
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
                    self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
                }
            }
        }
    }

    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
