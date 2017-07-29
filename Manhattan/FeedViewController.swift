//
//  FeedViewController.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import ExpandableLabel

var navController : UINavigationController?

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , ExpandableLabelDelegate, VideoCellDelegate, PhotoCellDelegate, BlogCellDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var expandableStates : Array<Bool>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        
        navController = self.navigationController
        
        expandableStates = [Bool](repeating: true, count: 10)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
            cell.lbBlogContent.delegate = self
            cell.lbBlogContent.text = "This app is for learning sth online. You can just install it and login with your email or facebook. You can see some posts and can learn from courses. Messaging and searching feature is embedded. You can also follow other users to see the posts they have posted. Of course you can manage your posts and courses on your profile page. Happy using the app! :)"
            cell.lbBlogContent.collapsed = expandableStates[indexPath.row]
            cell.index = indexPath.row
            cell.delegate = self
            cell.initCell()
            return cell
        } else if indexPath.row % 3 == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    // Expandable Label Delegate
    
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            expandableStates[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            expandableStates[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool {
        return true
    }
    
    // Cell Delegates
    
    func didSelectComment(_ index: Int, _ type: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectProfile(_ index: Int, _ type: String) {
        
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
