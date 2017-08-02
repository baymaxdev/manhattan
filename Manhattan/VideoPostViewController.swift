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

class VideoPostViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var vwPlayer: BMCustomPlayer!
    @IBOutlet weak var tfDescription: FloatLabelTextField!
    @IBOutlet weak var btnChoose: UIButton!
    
    var delegate: AppDelegate?
    var isRecord: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = UIApplication.shared.delegate as? AppDelegate
        btnChoose.layer.cornerRadius = btnChoose.frame.height / 2
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .none
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChoose(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Record a Video", style: .default) { (_ alert: UIAlertAction) in
            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                //picker.cameraCaptureMode = .video
                //picker.modalPresentationStyle = .fullScreen
                picker.mediaTypes = [kUTTypeMovie as String]
                //picker.showsCameraControls = true
                picker.videoMaximumDuration = 30.0
                picker.delegate = self
                self.isRecord = true
                self.present(picker, animated: true, completion: nil)
            }
            else {
                self.delegate?.showAlert(vc: self, msg: "Sorry, this device has no camera.")
            }
        }
        
        let album = UIAlertAction(title: "Upload From Camera Roll", style: .default) { (_ alert: UIAlertAction) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.delegate = self
            self.isRecord = false
            self.present(picker, animated: true, completion: nil)
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(album)
        sheet.addAction(camera)
        self.present(sheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType]
        
        if let type = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as String {
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? URL
                    if let url = urlOfVideo {
                        print(url)
                        if isRecord == true {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                            }) { saved, error in
                                if saved {
                                    let fetchOptions = PHFetchOptions()
                                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                                    
                                    // After uploading we fetch the PHAsset for most recent video and then get its current location url
                                    
                                    let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                                    PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                                        let newObj = avurlAsset as! AVURLAsset
                                        let asset = BMPlayerResource(url: newObj.url)
                                        self.vwPlayer.setVideo(resource: asset)
                                        // This is the URL we need now to access the video from gallery directly.
                                    })
                                }
                            }
                        } else {
                            let asset = BMPlayerResource(url: url)
                            self.vwPlayer.setVideo(resource: asset)
                        }
                        
                    }
                } 
            }
        }
        
        dismiss(animated:true, completion: nil)
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
