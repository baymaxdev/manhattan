//
//  TabBarViewController.swift
//  Manhattan
//
//  Created by gOd on 7/26/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController ,UITabBarControllerDelegate {

    var dele: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        dele = UIApplication.shared.delegate as? AppDelegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 4 {
            dele?.curUserId = (dele?.user?.id)!
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
