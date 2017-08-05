//
//  SearchCell.swift
//  Manhattan
//
//  Created by gOd on 8/3/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {


    @IBOutlet weak var lbTwo: UILabel!
    @IBOutlet weak var lbOne: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
