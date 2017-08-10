//
//  VideoCell.swift
//  Manhattan
//
//  Created by gOd on 7/27/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit

protocol VideoCellDelegate {
    func didSelectComment(_ index: Int)
    
    func didSelectProfile(_ index: Int)
    
    func didSelectLike(_ index: Int)
}

class VideoCell: UITableViewCell {

    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLikeCnt: UILabel!
    @IBOutlet weak var lbCommentCnt: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var vwPlayer: BMCustomPlayer!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var vwBack: UIView!
    
    var index: Int?
    var delegate: VideoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        
        vwBack.layer.masksToBounds = false
        vwBack.layer.shadowColor = UIColor.black.cgColor
        vwBack.layer.shadowOffset = CGSize(width: 2, height: 2)
        vwBack.layer.shadowOpacity = 0.7
        vwBack.layer.shadowRadius = 1.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onComment(_ sender: Any) {
        delegate?.didSelectComment(index!)
    }
    
    @IBAction func onProfile(_ sender: Any) {
        delegate?.didSelectProfile(index!)
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
        
        delegate?.didSelectLike(index!)
    }
}
