/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /*
        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL").responseJSON { response in
            if response.result.isSuccess {
                // convert data to dictionary array
                let result:NSArray = response.value as! NSArray
                if result.count > 0 {
                    for data in result {
                        let adoption = PFObject(className: "Adoption")
                        adoption["albumFile"] = (data as! Dictionary)["album_file"]
                        adoption["albumUpdate"]  = (data as! Dictionary)["album_update"]
                        adoption["animalAreaPkid"]  = (data as! Dictionary)["animal_area_pkid"]
                        adoption["animalBacterin"]  = (data as! Dictionary)["animal_bacterin"]
                        adoption["animalBodytype"]  = (data as! Dictionary)["animal_bodytype"]
                        adoption["animalCaption"]  = (data as! Dictionary)["animal_caption"]
                        adoption["animalCloseddate"]  = (data as! Dictionary)["animal_closeddate"]
                        adoption["animalColour"]  = (data as! Dictionary)["animal_colour"]
                        adoption["animalCreatetime"]  = (data as! Dictionary)["animal_createtime"]
                        adoption["animalFoundplace"]  = (data as! Dictionary)["animal_foundplace"]
                        adoption["animalId"]  = (data as! Dictionary)["animal_id"]
                        adoption["animalKind"]  = (data as! Dictionary)["animal_kind"]
                        adoption["animalOpendate"]  = (data as! Dictionary)["animal_opendate"]
                        adoption["animalPlace"]  = (data as! Dictionary)["animal_place"]
                        adoption["animalRemark"]  = (data as! Dictionary)["animal_remark"]
                        adoption["animalSex"]  = (data as! Dictionary)["animal_sex"]
                        adoption["animalShelterPkid"]  = (data as! Dictionary)["animal_shelter_pkid"]
                        adoption["animalStatus"]  = (data as! Dictionary)["animal_status"]
                        adoption["animalSterilization"]  = (data as! Dictionary)["animal_sterilization"]
                        adoption["animalSubid"]  = (data as! Dictionary)["animal_subid"]
                        adoption["animalTitle"]  = (data as! Dictionary)["animal_title"]
                        adoption["animalUpdate"]  = (data as! Dictionary)["animal_update"]
                        adoption["cDate"]  = (data as! Dictionary)["cDate"]
                        adoption["shelterAddress"]  = (data as! Dictionary)["shelter_address"]
                        adoption["shelterName"]  = (data as! Dictionary)["shelter_name"]
                        adoption["shelterTel"]  = (data as! Dictionary)["shelter_tel"]

                        // 要先判斷資料庫是不是已經有了，有了就不用再上傳更新

                        adoption.saveInBackground(block: { (success, error) in
                            if (success) {
                                print("save")
                            } else {
                                print("error")
                            }
                        })
                    }
                }
            } else {
                print("error: \(String(describing: response.error))")
            }
        }
        */
        /*
        let urlString:String = "http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL"
        var url:NSURL!
        url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"

        var response:URLResponse?

        do {
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData
            let datastring = NSString(data: received! as Data, encoding: String.Encoding.utf8.rawValue)
            print(datastring as Any)
        } catch let error as NSError {
            print(error.code)
            print(error.description)
        }
        */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
