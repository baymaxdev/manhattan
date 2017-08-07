//
//  BlogCell.swift
//  Manhattan
//
//  Created by gOd on 7/29/17.
//  Copyright © 2017 gOd. All rights reserved.
//

import UIKit
import ExpandableLabel

protocol BlogCellDelegate {
    func didSelectComment(_ index: Int, _ type: String)
    
    func didSelectProfile(_ index: Int, _ type: String)
}

class BlogCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbCommentCnt: UILabel!
    @IBOutlet weak var lbLikeCnt: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbBlogTitle: UILabel!
    @IBOutlet weak var vwBlogTitle: UIView!
    @IBOutlet weak var vwBlogContent: UIView!
    @IBOutlet weak var lbBlogContent: ExpandableLabel!
    @IBOutlet weak var vwBack: UIView!
    
    var index: Int?
    var delegate: BlogCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        vwBlogTitle.layer.cornerRadius = 10
        vwBlogContent.layer.cornerRadius = 10
        
        vwBlogTitle.layer.masksToBounds = false
        vwBlogTitle.layer.shadowColor = UIColor.black.cgColor
        vwBlogTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
        vwBlogTitle.layer.shadowOpacity = 0.7
        vwBlogTitle.layer.shadowRadius = 1.0
        
        vwBack.layer.masksToBounds = false
        vwBack.layer.shadowColor = UIColor.black.cgColor
        vwBack.layer.shadowOffset = CGSize(width: 2, height: 2)
        vwBack.layer.shadowOpacity = 0.7
        vwBack.layer.shadowRadius = 1.0
        
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbBlogContent.collapsed = true
        lbBlogContent.text = nil
    }
    
    func initCell()
    {
        let attributedStr = NSMutableAttributedString(string: "More")
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: APP_COLOR, range: NSMakeRange(0, attributedStr.length))
        lbBlogContent.collapsedAttributedLink = attributedStr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onComment(_ sender: Any) {
        delegate?.didSelectComment(index!, "blog")
    }
    
    @IBAction func onProfile(_ sender: Any) {
        delegate?.didSelectProfile(index!, "blog")
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
