//
//  BMPlayerCustomControlView.swift
//  BMPlayer
//
//  Created by BrikerMan on 2017/4/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BMPlayer

class BMPlayerCustomControlView: BMPlayerControlView {
    
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        hideLoader()
        fullscreenButton.isHidden = true
    }
    
    
    override func updateUI(_ isForFullScreen: Bool) {
        super.updateUI(isForFullScreen)
        backButton.isHidden = !isForFullScreen
        if (isForFullScreen) {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.tabBarController?.tabBar.isHidden = true
        } else {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    override func controlViewAnimation(isShow: Bool) {
    }
    
    @objc func onPlaybackRateButtonPressed() {
        
    }
    
    
    
    @objc func onRotateButtonPressed() {
        
    }
}
