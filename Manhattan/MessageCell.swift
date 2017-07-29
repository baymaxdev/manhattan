//
//  MessageCell.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    
    var index: Int?
    
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
