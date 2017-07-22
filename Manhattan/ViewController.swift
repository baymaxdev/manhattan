//
//  ViewController.swift
//  Manhattan
//
//  Created by gOd on 7/21/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import JJMaterialTextField

class ViewController: UIViewController {

    @IBOutlet weak var btnfacebook: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    
    @IBOutlet weak var tfEmail: JJMaterialTextfield!
    @IBOutlet weak var tfPassword: JJMaterialTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initialize()
    }
    
    func initialize() {
        btnfacebook.layer.cornerRadius = btnfacebook.frame.height / 2
        btnSignin.layer.cornerRadius = btnSignin.frame.height / 2
        
        tfEmail.enableMaterialPlaceHolder = true
        tfPassword.enableMaterialPlaceHolder = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFacebook(_ sender: Any) {
    }
}

