//
//  ProfileMainViewController.swift
//  Manhattan
//
//  Created by gOd on 7/24/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import MXSegmentedPager

class ProfileMainViewController: MXSegmentedPagerController {

    @IBOutlet weak var lbMentor: UILabel!
    @IBOutlet weak var lbCourses: UILabel!
    @IBOutlet weak var lbStudents: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderWidth = 3
        imgAvatar.layer.borderColor = UIColor(red: 0, green: 128.0/255.0, blue: 200/255.0, alpha: 1.0).cgColor
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
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 0, green: 128/255.0, blue: 200/255.0, alpha: 1.0)]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor(red: 0, green: 128/255.0, blue: 200/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
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
