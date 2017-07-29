//
//  PopupViewController.swift
//  Manhattan
//
//  Created by gOd on 7/28/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import MIBlurPopup

class PopupViewController: UIViewController {

    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var vwCont: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension PopupViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return vwCont ?? UIView()
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .regular
    }
    var initialScaleAmmount: CGFloat {
        return 0.5
    }
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}
