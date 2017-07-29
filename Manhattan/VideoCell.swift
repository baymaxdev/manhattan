//
//  VideoCell.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
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

    @IBAction func onComment(_ sender: Any) {
    }
    
    @IBAction func onLike(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3/1.5, animations: {
            self.btnLike.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (bool: Bool) in
            UIView.animate(withDuration: 0.3/1.5, animations: {
                self.btnLike.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: { (bool: Bool) in
                UIView.animate(withDuration: 0.3/1.5, animations: {
                    self.btnLike.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        }
        
        if btnLike.isSelected {
            btnLike.isSelected = false
        } else {
            btnLike.isSelected = true
        }
    }
}
