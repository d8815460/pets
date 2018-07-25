//
//  ProfileCell.swift
//  ezcareme
//
//  Created by 陳駿逸 on 2016/12/18.
//  Copyright © 2016年 陳駿逸. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol ProfileCellDelegate {
    func didSelectedFavoriteButtonPressed(cell:ProfileCell, giver: PFUser) //自行命名
}

class ProfileCell: PFTableViewCell {

    @IBOutlet var favoritesButton: UIButton!
    @IBOutlet var payLabel: UILabel!
    @IBOutlet var payPerLabel: UILabel!
    @IBOutlet var ratingButton: UIButton!
    @IBOutlet var serviceNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userJobTitle: UILabel!
    @IBOutlet var thumbnailImageView: PFImageView!
    @IBOutlet var thumbnailWrapperView: UIView!
    @IBOutlet var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet fileprivate var starImageViews: [UIImageView]?
    
    var giver:PFUser!
    var delegate:ProfileCellDelegate?
    
    /**
     Customize the view with custom font and colors for the labels. Set a constraint to be able to have a dynamic cell size according to the text that needs to be displayed
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let contentViewConstraint = NSLayoutConstraint(item:contentView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.greaterThanOrEqual, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:277.0)
        contentView.addConstraint(contentViewConstraint)
        downloadIndicator.hidesWhenStopped = true
        self.ratingButton.layer.cornerRadius = 53.0/2.0
        self.ratingButton.clipsToBounds = true
        self.ratingButton.layer.masksToBounds = true
    }

    /**
     Called when the user scrolls the listView to achieve the parallax effect
     
     - parameter offset: the value which the imageView's frame should be offsetted
     */
    func offsetImageView(_ offset: CGPoint) {
        thumbnailImageView.frame = thumbnailImageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    /**
     Prepare the cell for reuse, reset the imageView's image so it doesn't show a wrong image
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    /// Starts animating the download indicator
    func startAnimatingDownloadIndicator() {
        downloadIndicator.startAnimating()
    }
    
    /// Stops animating the download indicator
    func stopAnimatingDownloadIndicator() {
        downloadIndicator.stopAnimating()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate?.didSelectedFavoriteButtonPressed(cell:self, giver: self.giver)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Configures this instance with passed `destinationName` and `locationText`.
     
     - parameter destinationName:	`String` optional.
     - parameter locationText:	`String` optional.
     */
    func configure(rating: Int) {
        
        guard let starImageViews = starImageViews else {
            return
        }
        
        starImageViews.enumerated()
            .forEach { index, imageView in
                
                let insideRating = index < rating
                let starImage = insideRating ? UIImage.yellowStar() : UIImage.greyStar()
                
                imageView.image = starImage
        }
    }
}

extension UIImage {

    static func greyStar() -> UIImage? {
        return UIImage(named: "icoStarGrey")
    }

    static func yellowStar() -> UIImage? {
        return UIImage(named: "icoStarYellow")
    }
}
