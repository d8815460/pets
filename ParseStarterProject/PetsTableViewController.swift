//
//  PetsTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/7/28.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SDWebImage

class PetsTableViewController: PFQueryTableViewController {

    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        self.loadingViewEnabled = true
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
        self.parseClassName = className
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        // Configure the PFQueryTableView
        self.parseClassName = "Pets"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func queryForTable() -> PFQuery<PFObject> {
        return super.queryForTable().order(byAscending: "updateAt")
    }

    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)
        print("objects = \(String(describing: objects?.count))")
    }
    
    // MARK: TableView

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {


        let cellIdentifier = "profileCell"

        if (indexPath.row == ((self.objects?.count)! - 1) && (self.objects?.count)! > 99) {
            // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
            let cell = self.tableView(tableView, cellForNextPageAt: indexPath)
            return cell
        } else {
            var cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProfileCell

            let imageFile = object?.object(forKey: "imageFile") as! PFFile
            imageFile.getDataInBackground { (imageData, error) in
                cell.thumbnailImageView.image = UIImage(data: imageData!)
            }

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
        //        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == ( self.objects!.count - 1 ) {
            self.loadNextPage()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects!.count
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
