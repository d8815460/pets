//
//  PetsFeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/8/17.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import LoadMoreTableViewController
import Parse

class PetsFeedTableViewController: LoadMoreTableViewController, PetCellDelegate {

    var objects:[PFObject]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        fetchSourceObjects = { [weak self] completion in
            PFCloud.callFunction(inBackground: "getRandom", withParameters: [:]) { (result, error) in
                var refreshing:Bool = false
                DispatchQueue.main.async {
                    refreshing = self?.refreshControl?.isRefreshing == true
                    if refreshing { self?.refreshControl?.endRefreshing() }
                }
                self?.objects = result as? [PFObject]
                completion((self?.objects)!, true)
            }
        }
        
        configureCell = { [weak self] cell, row in
            let aCell: petCell = self?.tableView.dequeueReusableCell(withIdentifier: "petCell") as! petCell
            aCell.delegate = self
            let object = (self?.sourceObjects[row] as! PFObject)
            aCell.petObject = (self?.sourceObjects[row] as! PFObject)
            aCell.usernameBtn.setTitle((object.object(forKey: kPAPVideosUserKey) as! PFUser).username, for: .normal)
            let file:PFFile = object.object(forKey: kPAPVideosVideoThumbnailKey) as! PFFile
            aCell.picImg?.sd_setShowActivityIndicatorView(true)
            aCell.picImg?.sd_setIndicatorStyle(.gray)
            aCell.picImg?.sd_setImage(with: URL(string: file.url!), completed: { (image, error, type, url) in
                
            })
            return aCell
        }
        
        didSelectRow = { [weak self] row in
            let video = self?.sourceObjects[row]
//            self?.performSegue(withIdentifier: "detail", sender: video)
        }
    }
    
    fileprivate func setupUI() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: ""), style: .plain, target: self, action: #selector(clear))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Refresh", comment: ""), style: .plain, target: self, action: #selector(refresh))
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func clear() {
        refreshData(immediately: true)
    }
    
    @objc func refresh() {
        refreshData(immediately: false)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
