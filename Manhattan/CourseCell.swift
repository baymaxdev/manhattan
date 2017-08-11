//
//  CourseCell.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

protocol CourseCellDelegate {
    func didSelectDetail(_ index: Int)
    
    func didSelectProfile(_ index: Int)
}

class CourseCell: UITableViewCell {

    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var index: Int?
    var delegate: CourseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //vwContainer.layer.cornerRadius = 10
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        
        vwContainer.layer.masksToBounds = false
        //vwContainer.layer.shadowColor = UIColor(red: 0, green: 0.5, blue: 200/255.0, alpha: 1.0).cgColor
        vwContainer.layer.shadowColor = UIColor.black.cgColor
        vwContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
        vwContainer.layer.shadowOpacity = 0.5
        vwContainer.layer.shadowRadius = 2.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onProfile(_ sender: Any) {
        delegate?.didSelectProfile(index!)
    }
    
    @IBAction func onDetail(_ sender: Any) {
        delegate?.didSelectDetail(index!)
    }
}
