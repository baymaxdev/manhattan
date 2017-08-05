//
//  ViewController.swift
//  Manhattan
//
//  Created by gOd on 7/21/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField
import FacebookCore
import FacebookLogin
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class ViewController: UIViewController ,NVActivityIndicatorViewable{

    @IBOutlet weak var btnfacebook: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    @IBOutlet weak var tfEmail: JJMaterialTextfield!
    @IBOutlet weak var tfPassword: JJMaterialTextfield!
    
    var delegate: AppDelegate?
    //var activityIndicator: NVActivityIndicatorView?
    
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .custom("user_birthday") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        initialize()
    }
    
    func initialize() {
        btnfacebook.layer.cornerRadius = btnfacebook.frame.height / 2
        btnSignin.layer.cornerRadius = btnSignin.frame.height / 2
        
        tfEmail.enableMaterialPlaceHolder = true
        tfPassword.enableMaterialPlaceHolder = true
    }

    @IBAction func onSignin(_ sender: Any) {
        if (tfEmail.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Email field is required", action: nil)
        } else if (tfPassword.text?.isEmpty)! {
            delegate?.showAlert(vc: self, msg: "Password field is required", action: nil)
        } else {
            delegate?.showLoader(vc: self)
            self.didLogin(method: "Normal", user: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
    
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            delegate?.showLoader(vc: self)
            didLoginWithFacebook()
        case .failed(_):
            break
        default: break
        }
    }
    
    private func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let _ = facebookUser.email {
                    self.delegate?.user = facebookUser
                    self.didLogin(method: "Facebook", user: facebookUser)
                }
            })
        }
    }
    
    private func didLogin(method: String, user: User?) {
        
        var serverURL = BASE_URL
        var parameters : [String : Any?]
        
        if method == "Normal" {
            serverURL += LOGIN_URL
            parameters = ["email": tfEmail.text, "password": tfPassword.text]
        } else {
            serverURL += FBLOGIN_URL
            parameters = ["email": user?.email]
        }
        
        Alamofire.request(serverURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { (resData) -> Void in
            self.delegate?.hideLoader()
            
            if((resData.result.value) != nil) {
                let swiftyJsonVar = JSON(resData.result.value!)
                
                
                if swiftyJsonVar["success"].boolValue == true {
                    let action = UIAlertAction(title: "OK", style: .default){ action in
                        let userObj = swiftyJsonVar["userObj"].dictionaryValue
                        self.delegate?.user = User()
                        self.delegate?.user?.setUser(userObj)
                        self.delegate?.configureTabBar()
                    }
                    self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: action)
                    return
                }
                self.delegate?.showAlert(vc: self, msg: swiftyJsonVar["message"].stringValue, action: nil)
                
            } else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, Fialed to connect to server.", action: nil)
            }
        }
    }
}

