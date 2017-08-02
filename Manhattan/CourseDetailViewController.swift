//
//  CourseDetailViewController.swift
//  Manhattan
//
//  Created by gOd on 7/31/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import AVFoundation
import BMPlayer

class CourseDetailViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vwPlayer: BMCustomPlayer!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let asset = BMPlayerResource(url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
        self.vwPlayer.setVideo(resource: asset)
        self.vwPlayer.play()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailCell") as! CourseDetailCell
        cell.imgThumbnail.image = thumbnail(URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Introduction", "Why do you use?", "Product Research"][section]
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func thumbnail(_ sourceURL:URL) -> UIImage {
        let asset = AVAsset(url: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print(error)
            return UIImage(named: "avatar")!
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
