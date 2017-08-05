//
//  GroupViewController.swift
//  Manhattan
//
//  Created by gOd on 8/2/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddGroup: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddGroup.layer.cornerRadius = btnAddGroup.frame.height / 2
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        tableView.tableFooterView = customView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.lbOne.text = "Group \(indexPath.row)"
        cell.lbTwo.text = "5 members"
        // Configure the cell...
        
        return cell
    }
    
    @IBAction func onAddGroup(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupViewController")
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
