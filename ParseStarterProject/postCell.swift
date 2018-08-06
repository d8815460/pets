//
//  postCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Synchronized

@objc(AYIPostCellDelegate)
protocol PostCellDelegate: NSObjectProtocol {
    @objc optional func postCellClickMoreButton(didClickPostMoreButton post: PFObject)
}

class postCell: PFTableViewCell {

    public weak var delegate: PostCellDelegate?

    @IBOutlet weak var avaView: UIView!

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var titleLbl: KILabel!
    
    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var uuidLbl: UILabel!

    public var adoptionObject: PFObject! {
        didSet {
            let attributesForAdoption = PAPCache.sharedCache.attributesForAdoption(adoption: self.adoptionObject)

            if attributesForAdoption != nil {
                self.likeLbl.text = String(PAPCache.sharedCache.likeCountForAdoption(adoption: self.adoptionObject))
            } else {
                // check if we can update the cache
                synchronized(self) {
                    let query: PFQuery = PAPUtility.queryForActivitiesOnAdoption(adoption: self.adoptionObject, cachePolicy: PFCachePolicy.networkOnly)
                    query.findObjectsInBackground(block: { (objects, error) in
                        if error != nil {
                            return
                        }
                        var likers = [PFUser]()
                        var commenters = [PFUser]()

                        var isLikedByCurrentUser = false

                        for activity in objects! {
                            if (activity.object(forKey: kPAPActivityTypeKey) as! String) == kPAPActivityTypeLike && activity.object(forKey: kPAPActivityFromUserKey) != nil {
                                likers.append(activity.object(forKey: kPAPActivityFromUserKey) as! PFUser)
                            } else if (activity.object(forKey: kPAPActivityTypeKey) as! String) == kPAPActivityTypeComment && activity.object(forKey: kPAPActivityFromUserKey) != nil {
                                commenters.append(activity.object(forKey: kPAPActivityFromUserKey) as! PFUser)
                            }

                            if (activity.object(forKey: kPAPActivityFromUserKey) as? PFUser)?.objectId == PFUser.current()!.objectId {
                                if (activity.object(forKey: kPAPActivityTypeKey) as! String) == kPAPActivityTypeLike {
                                    isLikedByCurrentUser = true
                                }
                            }
                        }

                        PAPCache.sharedCache.setAttributesForAdoption(adoption: self.adoptionObject, likers: likers, commenters: commenters, likedByCurrentUser: isLikedByCurrentUser)
                        self.likeLbl.text = PAPCache.sharedCache.likeCountForAdoption(adoption: self.adoptionObject!).description
                    })
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set ava image layer
        setAvaImgLayer()
        
        // double tap to like
        doubleTapLike()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func moreBtn_click(_ sender: Any) {
        guard let d = delegate else {
            return
        }
        if d.responds(to:
            #selector(PostCellDelegate.postCellClickMoreButton(didClickPostMoreButton:))) {
            d.postCellClickMoreButton!(didClickPostMoreButton: self.adoptionObject!)
        }
    }

    @IBAction func likeBtn_click(_ sender: Any) {
        
        // declare title of button
        let title = (sender as AnyObject).title(for: UIControlState())
        
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = (PFUser.current()?.username)!
            object["to"] = uuidLbl.text
            object.saveInBackground{ (success, error) in
                if success {
                    
                    print("liked")
                    self.likeBtn.setTitle("like", for: UIControlState())
                    
                    self.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState())
                    
                    // send notification if we liked to refresh TableView
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "liked"), object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.current()?.username {
                        
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = (PFUser.current()?.username)!
                        newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            }
            
            // if title != "unlike"
        }else{
            
            // request existing likes of current user to show post
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.current()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackground { (objects, error) in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackground { (success, error) in
                        if success { print("disliked")
                            
                            self.likeBtn.setTitle("unlike", for: UIControlState())
                            self.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "unlike"), for: UIControlState())
                            
                            // send notification if we liked to refresh TableView
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "liked"), object: nil)
                            
                            // delete like notification
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "like")
                            newsQuery.findObjectsInBackground{ (objects, error)  in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }}}}}}}}
    }// like clicked button action over line
}// postCell class over line

//custom functions
extension postCell {
    
    fileprivate func setAvaImgLayer(){
        self.avaImg.layer.cornerRadius = self.avaImg.bounds.size.width / 2
        self.avaImg.layer.borderWidth = 0
        self.avaImg.clipsToBounds = true
    }
    
    // double tap to like
    fileprivate func doubleTapLike(){
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(postCell.likeTap))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
    }
}

//custom functions selectors
extension postCell {
    
    @objc fileprivate func likeTap(){
        
        // create large like gray heart
        let likePic = UIImageView(image: #imageLiteral(resourceName: "unlike"))
        likePic.frame.size.width = picImg.frame.size.width / 1.5
        likePic.frame.size.height = likePic.frame.size.width
        likePic.center = picImg.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        // hide likePic with animation and transform to be smaller
        UIView.animate(withDuration: 0.4){
            likePic.alpha = 0
            likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        // declare title of button
        let originalLikeCount = likeBtn.title(for: UIControlState())
        var likeCount: Int = Int(likeLbl!.text!)!
        let liked: Bool = !likeBtn.isSelected

        if (liked) {
            likeCount += 1
            PAPCache.sharedCache.incrementLikerCountForAdoption(adoption: self.adoptionObject)
        } else {
            if likeCount > 0 {
                likeCount -= 1
            }
            PAPCache.sharedCache.decrementLikerCountForAdoption(adoption: self.adoptionObject)
        }

        PAPCache.sharedCache.setAdoptionIsLikedByCurrentUser(adoption: self.adoptionObject, liked: liked)

        likeLbl.text = String(likeCount)

        if liked {
            PAPUtility.likeAdoptionInBackground(adoption: self.adoptionObject, block: { (succeeded, error) in
                // FIXME: nil??? same as the original AnyPic. Dead code?

                if !succeeded {
                    self.likeLbl.text = originalLikeCount
                }
            })
        } else {
            PAPUtility.unlikeAdoptionInBackground(adoption: self.adoptionObject, block: { (succeeded, error) in
                // FIXME: nil??? same as the original AnyPic. Dead code?

                if !succeeded {
                    self.likeLbl.text = originalLikeCount
                }
            })
        }
    }//likeTap function over line
}
