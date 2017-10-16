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
    
    func didSelectCell(_ index: Int)
    
    func cellDidClose(_ index: Int)
    
    func cellDidOpen(_ index: Int)
}

class VideoCell: UITableViewCell {

    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwDuration: UIView!
    @IBOutlet weak var vwGradient: UIView!
    @IBOutlet weak var contentViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwRight: UIView!
    
    
    var index: Int?
    var delegate: VideoCellDelegate?
    var panStartPoint: CGPoint = CGPoint()
    var startingRightLayoutConstraintConstant: CGFloat = 0.0
    var kBounceValue: CGFloat = 0.0
    let padding: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor(red: 134/255.0, green: 162/255.0, blue: 189/255.0, alpha: 1.0).cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.shadowOpacity = 0.7
        self.contentView.layer.shadowRadius = 10.0
        
        vwBack.layer.cornerRadius = 10
        vwRight.layer.cornerRadius = 10
        
        vwDuration.layer.cornerRadius = 10
        vwDuration.clipsToBounds = true
        
        // Initialization code
        setGradient()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panThisCell))
        panGesture.delegate = self
        self.vwBack.addGestureRecognizer(panGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetConstraintContstants(toZero: false, notifyDelegateDidClose: false)
    }
    
    func panThisCell(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            panStartPoint = recognizer.translation(in: self.vwBack)
            startingRightLayoutConstraintConstant = contentViewRightConstraint.constant
            break
        case .changed:
            let currentPoint: CGPoint = recognizer.translation(in: self.vwBack)
            let deltaX: CGFloat = currentPoint.x - panStartPoint.x
            var panningLeft = false
            if currentPoint.x < panStartPoint.x {
                //1
                panningLeft = true
            }
            if startingRightLayoutConstraintConstant == padding {
                //2
                //The cell was closed and is now opening
                if !panningLeft {
                    let constant: CGFloat = max(-deltaX, 0)
                    //3
                    if constant == 0 {
                        //4
                        resetConstraintContstants(toZero: true, notifyDelegateDidClose: false)
                    }
                    else {
                        //5
                        contentViewRightConstraint.constant = constant
                    }
                }
                else {
                    let constant: CGFloat = min(-deltaX, buttonTotalWidth())
                    //6
                    if constant == buttonTotalWidth() {
                        //7
                        setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                    }
                    else {
                        //8
                        contentViewRightConstraint.constant = constant
                    }
                }
            } else {
                let adjustment: CGFloat = startingRightLayoutConstraintConstant - deltaX
                //1
                if !panningLeft {
                    let constant: CGFloat = max(adjustment, 0)
                    //2
                    if constant == 0 {
                        //3
                        resetConstraintContstants(toZero: true, notifyDelegateDidClose: false)
                    }
                    else {
                        //4
                        contentViewRightConstraint.constant = constant
                    }
                }
                else {
                    let constant: CGFloat = min(adjustment, buttonTotalWidth())
                    //5
                    if constant == buttonTotalWidth() {
                        //6
                        setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: false)
                    }
                    else {
                        //7
                        contentViewRightConstraint.constant = constant
                    }
                }
            }
            contentViewLeftConstraint.constant = -contentViewRightConstraint.constant + padding * 2
            break
        case .ended:
            if startingRightLayoutConstraintConstant == padding {
                //1
                //Cell was opening
                let halfOfButtonOne: CGFloat = vwRight.frame.width / 3
                //2
                if contentViewRightConstraint.constant >= halfOfButtonOne {
                    //3
                    //Open all the way
                    setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                }
                else {
                    //Re-close
                    resetConstraintContstants(toZero: true, notifyDelegateDidClose: true)
                }
            }
            else {
                //Cell was closing
                let buttonOnePlusHalfOfButton2: CGFloat = vwRight.frame.width / 3 * 2
                //4
                if contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2 {
                    //5
                    //Re-open all the way
                    setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
                }
                else {
                    //Close
                    resetConstraintContstants(toZero: true, notifyDelegateDidClose: true)
                }
            }
            break
        case .cancelled:
            if startingRightLayoutConstraintConstant == padding {
                //We were closed - reset everything to 0
                resetConstraintContstants(toZero: true, notifyDelegateDidClose: true)
            }
            else {
                //We were open - reset to the open state
                setConstraintsToShowAllButtons(true, notifyDelegateDidOpen: true)
            }
            break
        default:
            break
        }
    }
    
    func updateConstraintsIfNeeded(_ animated: Bool, completion: @escaping (_ finished: Bool) -> Void) {
        var duration: Float = 0
        if animated {
            duration = 0.1
        }
        UIView.animate(withDuration: duration as? TimeInterval ?? TimeInterval(), delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.layoutIfNeeded()
        }, completion: completion)
    }

    func buttonTotalWidth() -> CGFloat {
        return self.vwBack.frame.width - vwRight.frame.minX
    }
    
    func openCell() {
        setConstraintsToShowAllButtons(false, notifyDelegateDidOpen: false)
    }
    
    func resetConstraintContstants(toZero animated: Bool, notifyDelegateDidClose notifyDelegate: Bool) {
        if notifyDelegate {
            delegate?.cellDidClose(index!)
        }
        if startingRightLayoutConstraintConstant == padding && contentViewRightConstraint.constant == padding {
            //Already all the way closed, no bounce necessary
            return
        }
        contentViewRightConstraint.constant = padding
        contentViewLeftConstraint.constant = padding
        updateConstraintsIfNeeded(animated, completion: {(_ finished: Bool) -> Void in
            self.contentViewRightConstraint.constant = self.padding
            self.contentViewLeftConstraint.constant = self.padding
            self.updateConstraintsIfNeeded(animated, completion: {(_ finished: Bool) -> Void in
                self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant
            })
        })
    }
    
    func setConstraintsToShowAllButtons(_ animated: Bool, notifyDelegateDidOpen notifyDelegate: Bool) {
        if notifyDelegate {
            delegate?.cellDidOpen(index!)
        }
        //1
        if startingRightLayoutConstraintConstant == buttonTotalWidth() && contentViewRightConstraint.constant == buttonTotalWidth() {
            return
        }
        //2
        contentViewLeftConstraint.constant = -buttonTotalWidth() - kBounceValue + padding * 2
        contentViewRightConstraint.constant = buttonTotalWidth() + kBounceValue
        updateConstraintsIfNeeded(animated, completion: {(_ finished: Bool) -> Void in
            //3
            self.contentViewLeftConstraint.constant = -self.buttonTotalWidth() + self.padding * 2
            self.contentViewRightConstraint.constant = self.buttonTotalWidth()
            self.updateConstraintsIfNeeded(animated, completion: {(_ finished: Bool) -> Void in
                //4
                self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant
            })
        })
    }

    
    func setGradient() {
        let gradient = CAGradientLayer()
        
        //gradient.frame = vwBack.bounds
        let width = UIScreen.main.bounds.width - padding * 2
        let height = width * 9 / 16.0
        gradient.frame = CGRect(x: vwBack.bounds.origin.x, y: vwBack.bounds.origin.y, width: width, height: height)
        gradient.colors = [UIColor(white: 0, alpha: 0.7).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.5).cgColor]
        gradient.locations = [0, 0.25, 0.75, 1]
        vwGradient.layer.addSublayer(gradient)

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

    @IBAction func onSelectCell(_ sender: Any) {
        delegate?.didSelectCell(index!)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
