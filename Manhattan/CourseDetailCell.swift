//
//  CourseDetailCell.swift
//  Manhattan
//
//  Created by gOd on 7/31/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class CourseDetailCell: UITableViewCell {

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
