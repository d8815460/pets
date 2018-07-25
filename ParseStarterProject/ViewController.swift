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
import RealmSwift

class Adoption: Object {
    @objc dynamic var albumFile = ""
    @objc dynamic var albumUpdate = ""
    @objc dynamic var animalAreaPkid = 0
    @objc dynamic var animalBacterin = ""
    @objc dynamic var animalBodytype = ""
    @objc dynamic var animalCaption = ""
    @objc dynamic var animalCloseddate = Date()
    @objc dynamic var animalColour = ""
    @objc dynamic var animalCreatetime = Date()
    @objc dynamic var animalFoundplace = ""
    @objc dynamic var animalId = 0
    @objc dynamic var animalKind = ""
    @objc dynamic var animalOpendate = Date()
    @objc dynamic var animalPlace = ""
    @objc dynamic var animalRemark = ""
    @objc dynamic var animalSex = ""
    @objc dynamic var animalShelterPkid = 0
    @objc dynamic var animalStatus = ""
    @objc dynamic var animalSterilization = ""
    @objc dynamic var animalSubid = ""
    @objc dynamic var animalTitle = ""
    @objc dynamic var animalUpdate = Date()
    @objc dynamic var cDate = Date()
    @objc dynamic var shelterAddress = ""
    @objc dynamic var shelterName = ""
    @objc dynamic var shelterTel = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updateAt = Date()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL").responseJSON { response in
            if response.result.isSuccess {
                // convert data to dictionary array
                let result:NSArray = response.value as! NSArray
                if result.count > 0 {
                    for data in result {
                        let adoption = PFObject(className: "Adoption")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"

                        adoption["albumFile"] = (data as! Dictionary)["album_file"]
                        adoption["albumUpdate"]  = (data as! Dictionary)["album_update"]
                        adoption["animalAreaPkid"]  = (data as! Dictionary)["animal_area_pkid"]
                        adoption["animalBacterin"]  = (data as! Dictionary)["animal_bacterin"]
                        adoption["animalBodytype"]  = (data as! Dictionary)["animal_bodytype"]
                        adoption["animalCaption"]  = (data as! Dictionary)["animal_caption"]
                        if ((data as! NSDictionary)["animal_closeddate"] == nil || ((data as! NSDictionary)["animal_closeddate"]! as! String) == "") { } else {
                            let animalCloseddate = dateFormatter.date(from: (data as! NSDictionary)["animal_closeddate"]! as! String)
                            adoption["animalCloseddate"]  = animalCloseddate
                        }
                        adoption["animalColour"]  = (data as! Dictionary)["animal_colour"]
                        if ((data as! NSDictionary)["animal_createtime"] == nil || ((data as! NSDictionary)["animal_createtime"]! as! String) == "") { } else {
                            let animal_createtime = dateFormatter.date(from: (data as! NSDictionary)["animal_createtime"]! as! String)
                            adoption["animalCreatetime"]  = animal_createtime
                        }
                        adoption["animalFoundplace"]  = (data as! Dictionary)["animal_foundplace"]
                        adoption["animalId"]  = (data as! Dictionary)["animal_id"]
                        adoption["animalKind"]  = (data as! Dictionary)["animal_kind"]
                        if ((data as! NSDictionary)["animal_opendate"] == nil || ((data as! NSDictionary)["animal_opendate"]! as! String) == "") { } else {
                            let animalOpendate = dateFormatter.date(from: (data as! NSDictionary)["animal_opendate"]! as! String)
                            adoption["animalOpendate"]  = animalOpendate
                        }
                        adoption["animalPlace"]  = (data as! Dictionary)["animal_place"]
                        adoption["animalRemark"]  = (data as! Dictionary)["animal_remark"]
                        adoption["animalSex"]  = (data as! Dictionary)["animal_sex"]
                        adoption["animalShelterPkid"]  = (data as! Dictionary)["animal_shelter_pkid"]
                        adoption["animalStatus"]  = (data as! Dictionary)["animal_status"]
                        adoption["animalSterilization"]  = (data as! Dictionary)["animal_sterilization"]
                        adoption["animalSubid"]  = (data as! Dictionary)["animal_subid"]
                        adoption["animalTitle"]  = (data as! Dictionary)["animal_title"]
                        if ((data as! NSDictionary)["animal_update"] == nil || ((data as! NSDictionary)["animal_update"]! as! String) == "") { } else {
                            let animalUpdate = dateFormatter.date(from: (data as! NSDictionary)["animal_update"]! as! String)
                            adoption["animalUpdate"]  = animalUpdate
                        }
                        if ((data as! NSDictionary)["cDate"] == nil || ((data as! NSDictionary)["cDate"]! as! String) == "") { } else {
                            let cDate = dateFormatter.date(from: (data as! NSDictionary)["cDate"]! as! String)
                            adoption["cDate"]  = cDate
                        }
                        adoption["shelterAddress"]  = (data as! Dictionary)["shelter_address"]
                        adoption["shelterName"]  = (data as! Dictionary)["shelter_name"]
                        adoption["shelterTel"]  = (data as! Dictionary)["shelter_tel"]

                        // 要先判斷資料庫是不是已經有了，有了就不用再上傳更新
                        let realm = try! Realm()
                        let myAdoption = Adoption()
                        let adoptions = realm.objects(Adoption.self)
                        if adoptions.count == 0 {
                            adoption.saveInBackground(block: { (success, error) in
                                if (success) {
                                    print("save1")
                                    myAdoption.albumFile        = adoption["albumFile"] as! String
                                    myAdoption.albumUpdate      = adoption["albumUpdate"] as! String
                                    myAdoption.animalAreaPkid   = adoption["animalAreaPkid"] as! Int
                                    myAdoption.animalBacterin   = adoption["animalBacterin"] as! String
                                    myAdoption.animalBodytype   = adoption["animalBodytype"] as! String
                                    myAdoption.animalCaption    = adoption["animalCaption"] as! String
                                    if (adoption["animalCloseddate"] != nil) {
                                        myAdoption.animalCloseddate     = adoption["animalCloseddate"] as! Date
                                    }
                                    myAdoption.animalColour     = adoption["animalColour"] as! String
                                    if (adoption["animalCreatetime"] != nil) {
                                        myAdoption.animalCreatetime     = adoption["animalCreatetime"] as! Date
                                    }
                                    myAdoption.animalFoundplace = adoption["animalFoundplace"] as! String
                                    myAdoption.animalId         = adoption["animalId"] as! Int
                                    myAdoption.animalKind       = adoption["animalKind"] as! String
                                    if (adoption["animalOpendate"] != nil) {
                                        myAdoption.animalOpendate     = adoption["animalOpendate"] as! Date
                                    }
                                    myAdoption.animalPlace      = adoption["animalPlace"] as! String
                                    myAdoption.animalRemark     = adoption["animalRemark"] as! String
                                    myAdoption.animalSex        = adoption["animalSex"] as! String
                                    myAdoption.animalShelterPkid = adoption["animalShelterPkid"] as! Int
                                    myAdoption.animalStatus     = adoption["animalStatus"] as! String
                                    myAdoption.animalSterilization = adoption["animalSterilization"] as! String
                                    myAdoption.animalSubid      = adoption["animalSubid"] as! String
                                    myAdoption.animalTitle      = adoption["animalTitle"] as! String
                                    if (adoption["animalUpdate"] != nil) {
                                        myAdoption.animalUpdate     = adoption["animalUpdate"] as! Date
                                    }
                                    if (adoption["cDate"] != nil) {
                                        myAdoption.cDate            = adoption["cDate"] as! Date
                                    }
                                    myAdoption.shelterAddress   = adoption["shelterAddress"] as! String
                                    myAdoption.shelterName      = adoption["shelterName"] as! String
                                    myAdoption.shelterTel       = adoption["shelterTel"] as! String
                                    myAdoption.createdAt        = adoption.createdAt!
                                    myAdoption.updateAt         = adoption.updatedAt!
                                    // Get the default Realm
                                    let realm = try! Realm()
                                    // Persist your data easily
                                    try! realm.write {
                                        realm.add(myAdoption)
                                    }
                                } else {
                                    print("error")
                                }
                            })
                        } else {
                            let isExists = adoptions.filter("animalId")
                            if isExists.count > 0 {
                                if (adoptions.first?.animalUpdate)! == ((data as! NSDictionary)["animalUpdate"] as! Date)  {
                                    // do nothing...
                                } else {
                                    adoption.saveInBackground(block: { (success, error) in
                                        if (success) {
                                            print("save2")
                                            myAdoption.albumFile        = adoption["albumFile"] as! String
                                            myAdoption.albumUpdate      = adoption["albumUpdate"] as! String
                                            myAdoption.animalAreaPkid   = adoption["animalAreaPkid"] as! Int
                                            myAdoption.animalBacterin   = adoption["animalBacterin"] as! String
                                            myAdoption.animalBodytype   = adoption["animalBodytype"] as! String
                                            myAdoption.animalCaption    = adoption["animalCaption"] as! String
                                            if (adoption["animalCloseddate"] != nil) {
                                                myAdoption.animalCloseddate     = adoption["animalCloseddate"] as! Date
                                            }
                                            myAdoption.animalColour     = adoption["animalColour"] as! String
                                            if (adoption["animalCreatetime"] != nil) {
                                                myAdoption.animalCreatetime     = adoption["animalCreatetime"] as! Date
                                            }
                                            myAdoption.animalFoundplace = adoption["animalFoundplace"] as! String
                                            myAdoption.animalId         = adoption["animalId"] as! Int
                                            myAdoption.animalKind       = adoption["animalKind"] as! String
                                            if (adoption["animalOpendate"] != nil) {
                                                myAdoption.animalOpendate     = adoption["animalOpendate"] as! Date
                                            }
                                            myAdoption.animalPlace      = adoption["animalPlace"] as! String
                                            myAdoption.animalRemark     = adoption["animalRemark"] as! String
                                            myAdoption.animalSex        = adoption["animalSex"] as! String
                                            myAdoption.animalShelterPkid = adoption["animalShelterPkid"] as! Int
                                            myAdoption.animalStatus     = adoption["animalStatus"] as! String
                                            myAdoption.animalSterilization = adoption["animalSterilization"] as! String
                                            myAdoption.animalSubid      = adoption["animalSubid"] as! String
                                            myAdoption.animalTitle      = adoption["animalTitle"] as! String
                                            if (adoption["animalUpdate"] != nil) {
                                                myAdoption.animalUpdate     = adoption["animalUpdate"] as! Date
                                            }
                                            if (adoption["cDate"] != nil) {
                                                myAdoption.cDate            = adoption["cDate"] as! Date
                                            }
                                            myAdoption.shelterAddress   = adoption["shelterAddress"] as! String
                                            myAdoption.shelterName      = adoption["shelterName"] as! String
                                            myAdoption.shelterTel       = adoption["shelterTel"] as! String
                                            myAdoption.createdAt        = adoption.createdAt!
                                            myAdoption.updateAt         = adoption.updatedAt!
                                            // Get the default Realm
                                            let realm = try! Realm()
                                            // Persist your data easily
                                            try! realm.write {
                                                realm.add(myAdoption)
                                            }
                                        } else {
                                            print("error")
                                        }
                                    })
                                }
                            } else {
                                adoption.saveInBackground(block: { (success, error) in
                                    if (success) {
                                        print("save3")
                                        myAdoption.albumFile        = adoption["albumFile"] as! String
                                        myAdoption.albumUpdate      = adoption["albumUpdate"] as! String
                                        myAdoption.animalAreaPkid   = adoption["animalAreaPkid"] as! Int
                                        myAdoption.animalBacterin   = adoption["animalBacterin"] as! String
                                        myAdoption.animalBodytype   = adoption["animalBodytype"] as! String
                                        myAdoption.animalCaption    = adoption["animalCaption"] as! String
                                        if (adoption["animalCloseddate"] != nil) {
                                            myAdoption.animalCloseddate     = adoption["animalCloseddate"] as! Date
                                        }
                                        myAdoption.animalColour     = adoption["animalColour"] as! String
                                        if (adoption["animalCreatetime"] != nil) {
                                            myAdoption.animalCreatetime     = adoption["animalCreatetime"] as! Date
                                        }
                                        myAdoption.animalFoundplace = adoption["animalFoundplace"] as! String
                                        myAdoption.animalId         = adoption["animalId"] as! Int
                                        myAdoption.animalKind       = adoption["animalKind"] as! String
                                        if (adoption["animalOpendate"] != nil) {
                                            myAdoption.animalOpendate     = adoption["animalOpendate"] as! Date
                                        }
                                        myAdoption.animalPlace      = adoption["animalPlace"] as! String
                                        myAdoption.animalRemark     = adoption["animalRemark"] as! String
                                        myAdoption.animalSex        = adoption["animalSex"] as! String
                                        myAdoption.animalShelterPkid = adoption["animalShelterPkid"] as! Int
                                        myAdoption.animalStatus     = adoption["animalStatus"] as! String
                                        myAdoption.animalSterilization = adoption["animalSterilization"] as! String
                                        myAdoption.animalSubid      = adoption["animalSubid"] as! String
                                        myAdoption.animalTitle      = adoption["animalTitle"] as! String
                                        if (adoption["animalUpdate"] != nil) {
                                            myAdoption.animalUpdate     = adoption["animalUpdate"] as! Date
                                        }
                                        if (adoption["cDate"] != nil) {
                                            myAdoption.cDate            = adoption["cDate"] as! Date
                                        }
                                        myAdoption.shelterAddress   = adoption["shelterAddress"] as! String
                                        myAdoption.shelterName      = adoption["shelterName"] as! String
                                        myAdoption.shelterTel       = adoption["shelterTel"] as! String
                                        myAdoption.createdAt        = adoption.createdAt!
                                        myAdoption.updateAt         = adoption.updatedAt!
                                        // Get the default Realm
                                        let realm = try! Realm()
                                        // Persist your data easily
                                        try! realm.write {
                                            realm.add(myAdoption)
                                        }
                                    } else {
                                        print("error")
                                    }
                                })
                            }

                        }
                    }
                }
            } else {
                print("error: \(String(describing: response.error))")
            }
        }

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
