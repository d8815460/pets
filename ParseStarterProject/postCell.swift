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

class postCell: PFTableViewCell {
    
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
extension postCell{
    
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
extension postCell{
    
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
        let title = likeBtn.title(for: UIControlState())
        
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()?.username
            object["to"] = uuidLbl.text
            object.saveInBackground { (success, error) in
                if success {
                    print("liked")
                    self.likeBtn.setTitle("like", for: UIControlState())
                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState())
                    
                    // send notification if we liked to refresh TableView
                    NotificationCenter.default.post(name:
                        Notification.Name(rawValue: "liked"), object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.current()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.current()?.username
                        newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }//send notification as like oveer line
                }//save in background success over line
            }//save in background closure over line
            
        } // if title == "unlike" over line
    }//likeTap function over line
    
}
