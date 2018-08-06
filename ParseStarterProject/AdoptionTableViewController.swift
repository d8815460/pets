//
//  AdoptionTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/7/23.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SDWebImage
import FormatterKit

class AdoptionTableViewController: PFQueryTableViewController, PostCellDelegate {

    var timeFormatter:TTTTimeIntervalFormatter?

    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        self.loadingViewEnabled = true
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 50
        self.parseClassName = className
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Adoption"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.timeFormatter == nil {
            self.timeFormatter = TTTTimeIntervalFormatter()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query:PFQuery<PFObject> = PFQuery(className: kPAPAdoptionClassKey)
        query.whereKeyExists(kPAPAdoptionAlbumFileKey)
        query.whereKey(kPAPAdoptionAlbumFileKey, notEqualTo: "")
//        query.order(byAscending: kPAPAdoptionAnimalCreatetimeKey)
        query.order(byDescending: kPAPAdoptionAnimalCreatetimeKey)
        return query
    }
    
    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)
        print("objects = \(String(describing: objects?.count))")
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {


        let cellIdentifier = "postCell"
        
        if (indexPath.row == ((self.objects?.count)! - 1)) {
            // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
            let cell = self.tableView(tableView, cellForNextPageAt: indexPath)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! postCell
            cell.delegate = self
            cell.adoptionObject = object
            cell.usernameBtn.setTitle(object?["animalPlace"] as? String, for: .normal)
            if object?[kPAPAdoptionAnimalCreatetimeKey] != nil {
                cell.dateLbl.text = self.timeFormatter?.stringForTimeInterval(from: Date(), to: object?[kPAPAdoptionAnimalCreatetimeKey] as! Date)
            } else {
                cell.dateLbl.text = "無紀錄"
            }
            cell.picImg?.sd_setImage(with: URL(string: object?.object(forKey: kPAPAdoptionAlbumFileKey) as! String), completed: { (image, error, type, url) in
            })
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForNextPageAt indexPath: IndexPath) -> PFTableViewCell? {
        let LoadMoreCellIdentifier = "loadMore"
        
        var cell: PFTableViewCell? = tableView.dequeueReusableCell(withIdentifier: LoadMoreCellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: LoadMoreCellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.textLabel?.text = "載入更多"
        }
        return cell!
    }
    
    // MARK:- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == ( self.objects!.count - 1 ) {
            self.loadNextPage()
        } else {
//            self.performSegue(withIdentifier: "detail", sender: (self.objects?[indexPath.row])!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects!.count
    }

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

    func postCellClickMoreButton(didClickPostMoreButton post: PFObject) {
        self.performSegue(withIdentifier: "detail", sender: post)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "detail" {
            let view = segue.destination as! AdoptionDetailViewController
            let adoption = sender as! PFObject
            view.adoptionObject = adoption
            view.hidesBottomBarWhenPushed = true
        }
    }
}
