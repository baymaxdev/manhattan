//
//  VideoRecordViewController.swift
//  Manhattan
//
//  Created by gOd on 10/3/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import LLSimpleCamera
import MZTimerLabel

class VideoRecordViewController: UIViewController, MZTimerLabelDelegate {
    
    var errorLabel = UILabel()
    var snapButton = UIButton()
    var switchButton = UIButton()
    var settingsButton = UIButton()
    var camera = LLSimpleCamera()
    var timer = MZTimerLabel()
    var outputURL : URL?
    var delegate : AppDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.camera.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor.black
        
        let screenRect = UIScreen.main.bounds
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        self.camera.attach(to: self, withFrame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        self.camera.fixOrientationAfterCapture = true
        
        self.camera.onError = {(camera, error) -> Void in
            if(self.view.subviews.contains(self.errorLabel)){
                self.errorLabel.removeFromSuperview()
            }
            
            let label: UILabel = UILabel(frame: CGRect.zero)
            label.text = "We need permission for the camera and microphone."
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.sizeToFit()
            label.center = CGPoint(x: screenRect.size.width / 2.0, y: screenRect.size.height / 2.0)
            self.errorLabel = label
            self.view!.addSubview(self.errorLabel)
            
            let jumpSettingsBtn: UIButton = UIButton(frame: CGRect(x: 50, y: label.frame.origin.y + 50, width: screenRect.size.width - 100, height: 50))
            jumpSettingsBtn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
            jumpSettingsBtn.setTitle("Go Settings", for: UIControlState())
            jumpSettingsBtn.setTitleColor(UIColor.white, for: UIControlState())
            jumpSettingsBtn.layer.borderColor = UIColor.white.cgColor
            jumpSettingsBtn.layer.cornerRadius = 5
            jumpSettingsBtn.layer.borderWidth = 2
            jumpSettingsBtn.clipsToBounds = true
            jumpSettingsBtn.addTarget(self, action: #selector(self.jumpSettinsButtonPressed(_:)), for: .touchUpInside)
            jumpSettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            
            self.settingsButton = jumpSettingsBtn
            
            self.view!.addSubview(self.settingsButton)
            
            self.switchButton.isEnabled = false
            self.snapButton.isEnabled = false
        }
        
        if(LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable()){
            self.snapButton = UIButton(type: .custom)
            self.snapButton.frame = CGRect(x: 0, y: 0, width: 70.0, height: 70.0)
            self.snapButton.clipsToBounds = true
            self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
            self.snapButton.layer.borderColor = UIColor.white.cgColor
            self.snapButton.layer.borderWidth = 3.0
            self.snapButton.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            self.snapButton.layer.rasterizationScale = UIScreen.main.scale
            self.snapButton.layer.shouldRasterize = true
            self.snapButton.addTarget(self, action: #selector(self.snapButtonPressed(_:)), for: .touchUpInside)
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            self.snapButton.addGestureRecognizer(tap)
            self.view!.addSubview(self.snapButton)
            
            let vw = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            self.view.addSubview(vw)
            
            let vw1 = UIView(frame: CGRect(x: 0, y: 0, width: vw.frame.width, height: vw.frame.height))
            vw1.backgroundColor = UIColor.black
            vw1.alpha = 0.3
            vw.addSubview(vw1)
            
            self.timer = MZTimerLabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            self.timer.timerType = MZTimerLabelTypeStopWatch
            self.timer.backgroundColor = UIColor.clear
            self.timer.textColor = UIColor.white
            self.timer.textAlignment = NSTextAlignment.center
            self.timer.center = vw.center
            self.timer.timeFormat = "mm:ss"
            self.timer.delegate = self
            vw.addSubview(self.timer)
            
            self.switchButton = UIButton(type: .system)
            self.switchButton.frame = CGRect(x: 0, y: 0, width: 29.0 + 20.0, height: 22.0 + 20.0)
            self.switchButton.tintColor = UIColor.white
            self.switchButton.setImage(UIImage(named: "camera-switch.png"), for: UIControlState())
            self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.switchButton.addTarget(self, action: #selector(self.switchButtonPressed(_:)), for: .touchUpInside)
            self.switchButton.center = vw.center
            self.switchButton.frame.origin.x = vw.frame.width - 60
            self.view!.addSubview(self.switchButton)
            
            
        }
        else{
            let label: UILabel = UILabel(frame: CGRect.zero)
            label.text = "You must have a camera to take video."
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.sizeToFit()
            label.center = CGPoint(x: screenRect.size.width / 2.0, y: screenRect.size.height / 2.0)
            self.errorLabel = label
            self.view!.addSubview(self.errorLabel)
        }
    }
    
    func jumpSettinsButtonPressed(_ button: UIButton){
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    func switchButtonPressed(_ button: UIButton) {
        self.camera.togglePosition()
    }
    
    func snapButtonPressed(_ button: UIButton) {
        if(!camera.isRecording) {
            self.switchButton.isHidden = true
            self.snapButton.layer.borderColor = UIColor.red.cgColor
            self.snapButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            // start recording
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            outputURL = URL(fileURLWithPath: paths).appendingPathComponent("test").appendingPathExtension("mp4")
            self.camera.start()
            self.camera.startRecording(withOutputUrl: outputURL, didRecord: { (camera, outputFileUrl, error) in
            })
            self.timer.reset()
            self.timer.start()
        }
        else {
            self.switchButton.isHidden = false
            self.snapButton.layer.borderColor = UIColor.white.cgColor
            self.snapButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            self.camera.stop()
            self.camera.stopRecording()
            self.timer.pause()
        }
    }
    
    func doubleTapped() {
        if (outputURL != nil) {
            self.camera.stopRecording()
            self.dismiss(animated: true, completion: nil)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPostViewController") as! VideoPostViewController
            vc.videoUrl = outputURL
            navController?.pushViewController(vc, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        self.snapButton.center = self.view.center
        self.snapButton.frame.origin.y = self.view.bounds.height - 90
    }
    
    func applicationDocumentsDirectory()-> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func timerLabel(_ timerLabel: MZTimerLabel!, countingTo time: TimeInterval, timertype timerType: MZTimerLabelType) {
        if (time > 5) {
            self.switchButton.isHidden = false
            self.snapButton.layer.borderColor = UIColor.white.cgColor
            self.snapButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            self.camera.stop()
            self.camera.stopRecording()
            self.timer.pause()
            self.delegate?.showAlert(vc: self, msg: "Video Length must be less than 60s.", action: nil)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
}
