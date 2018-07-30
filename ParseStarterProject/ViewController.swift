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

func content(_ path:String)->String?{
    do {
        let content = try String(contentsOfFile:path, encoding:String.Encoding.utf8) as String//encoding: NSUTF8StringEncoding
        return content
    } catch {
        return nil
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /*
         * 用來爬官方資料的爬蟲，如果本地資料庫已經有了，就不再更新至Parse Server，減少call API的次數
         *
         */
//        self.queryFromAdoption()


        /*
         * 將爬蟲爬回來的照片及影片，上傳至Parse Server.
         */
//        self.saveInstagramPhotoAndVideo()

    }

    func saveInstagramPhotoAndVideo() {
        let fileName = "test"
        let fileType = "bundle"
        if var path = Bundle.main.path(forResource: fileName, ofType:fileType) {
            // use path
            path = path + "/pets"
            let postUser = PFUser(withoutDataWithObjectId: "0QPB4j01ZG")
            do{
                let fileList = try FileManager.default.contentsOfDirectory(atPath: path)

                for file in fileList{
                    let fileType = file.substring(from: file.index(file.endIndex, offsetBy: -3))
                    let userPhoto = PFObject(className:"Pets")
                    let fileName = "\(path)/\(file)"
                    if fileType == "jpg" {
                        let image = UIImage(named: fileName)
                        let imageData = UIImagePNGRepresentation(image!)
                        let imageFile = PFFile(name:file, data:imageData!)
                        userPhoto["imageFile"] = imageFile
                        userPhoto["fileName"] = file
                        userPhoto["type"] = fileType
                        userPhoto["user"] = postUser
                        userPhoto.saveInBackground { (success, error) in
                            if success {
                                print("save success")
                            } else {
                                print("save error")
                            }
                        }

                    } else {
                        let fileData = try PFFile(name: file, contentsAtPath: fileName)
                        userPhoto["videoFile"] = fileData
                        userPhoto["fileName"] = file
                        userPhoto["type"] = fileType
                        userPhoto["user"] = postUser
                        userPhoto.saveInBackground { (success, error) in
                            if success {
                                print("save success")
                            } else {
                                print("save error")
                            }
                        }
                    }
                }
            }
            catch{
                print("Cannot list directory")
            }
        }
    }

    func queryFromAdoption() {
        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL").responseJSON { response in
            if response.result.isSuccess {
                // convert data to dictionary array
                let result:NSArray = response.value as! NSArray
                if result.count > 0 {
                    for data in result {
                        let adoption = PFObject(className: kPAPAdoptionClassKey)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        adoption[kPAPAdoptionAlbumFileKey] = (data as! Dictionary)[kServerAdoptionAlbumFileKey]
                        adoption[kPAPAdoptionAlbumUpdateKey]  = (data as! Dictionary)[kServerAdoptionAlbumUpdateKey]
                        adoption[kPAPAdoptionAnimalAreaPkidKey]  = (data as! Dictionary)[kServerAdoptionAnimalAreaPkidKey]
                        adoption[kPAPAdoptionAnimalBacterinKey]  = (data as! Dictionary)[kServerAdoptionAnimalBacterinKey]
                        adoption[kPAPAdoptionAnimalBodytypeKey]  = (data as! Dictionary)[kServerAdoptionAnimalBodytypeKey]
                        adoption[kPAPAdoptionAnimalCaptionKey]  = (data as! Dictionary)[kServerAdoptionAnimalCaptionKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey]! as! String) == "") { } else {
                            let animalCloseddate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey]! as! String)
                            adoption[kPAPAdoptionAnimalCloseddateKey]  = animalCloseddate
                        }
                        adoption[kPAPAdoptionAnimalColourKey]  = (data as! Dictionary)[kServerAdoptionAnimalColourKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey] == nil || ((data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey]! as! String) == "") { } else {
                            let animal_createtime = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey]! as! String)
                            adoption[kPAPAdoptionAnimalCreatetimeKey]  = animal_createtime
                        }
                        adoption[kPAPAdoptionAnimalFoundplaceKey]  = (data as! Dictionary)[kServerAdoptionAnimalFoundplaceKey]
                        adoption[kPAPAdoptionAnimalIdKey]  = (data as! Dictionary)[kServerAdoptionAnimalIdKey]
                        adoption[kPAPAdoptionAnimalKindKey]  = (data as! Dictionary)[kServerAdoptionAnimalKindKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalOpendateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionAnimalOpendateKey]! as! String) == "") { } else {
                            let animalOpendate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalOpendateKey]! as! String)
                            adoption[kPAPAdoptionAnimalOpendateKey]  = animalOpendate
                        }
                        adoption[kPAPAdoptionAnimalPlaceKey]  = (data as! Dictionary)[kServerAdoptionAnimalPlaceKey]
                        adoption[kPAPAdoptionAnimalRemarkKey]  = (data as! Dictionary)[kServerAdoptionAnimalRemarkKey]
                        adoption[kPAPAdoptionAnimalSexKey]  = (data as! Dictionary)[kServerAdoptionAnimalSexKey]
                        adoption[kPAPAdoptionAnimalShelterPkidKey]  = (data as! Dictionary)[kServerAdoptionAnimalShelterPkidKey]
                        adoption[kPAPAdoptionAnimalStatusKey]  = (data as! Dictionary)[kServerAdoptionAnimalStatusKey]
                        adoption[kPAPAdoptionAnimalSterilizationKey]  = (data as! Dictionary)[kServerAdoptionAnimalSterilizationKey]
                        adoption[kPAPAdoptionAnimalSubidKey]  = (data as! Dictionary)[kServerAdoptionAnimalSubidKey]
                        adoption[kPAPAdoptionAnimalTitleKey]  = (data as! Dictionary)[kServerAdoptionAnimalTitleKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalUpdateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionAnimalUpdateKey]! as! String) == "") { } else {
                            let animalUpdate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalUpdateKey]! as! String)
                            adoption[kPAPAdoptionAnimalUpdateKey]  = animalUpdate
                        }
                        if ((data as! NSDictionary)[kServerAdoptionCDateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionCDateKey]! as! String) == "") { } else {
                            let cDate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionCDateKey]! as! String)
                            adoption[kPAPAdoptionCDateKey]  = cDate
                        }
                        adoption[kPAPAdoptionShelterAddressKey]  = (data as! Dictionary)[kServerAdoptionShelterAddressKey]
                        adoption[kPAPAdoptionShelterNameKey]  = (data as! Dictionary)[kServerAdoptionShelterNameKey]
                        adoption[kPAPAdoptionShelterTelKey]  = (data as! Dictionary)[kServerAdoptionShelterTelKey]

                        // 要先判斷資料庫是不是已經有了，有了就不用再上傳更新
                        let realm = try! Realm()
                        let myAdoption = Adoption()
                        let adoptions = realm.objects(Adoption.self)
                        if adoptions.count == 0 {
                            adoption.saveInBackground(block: { (success, error) in
                                if (success) {
                                    print("save1")
                                    self.myAdoptionSaveToRealm(myAdoption: myAdoption, adoption: adoption)
                                } else {
                                    print("error1")
                                }
                            })
                        } else {
                            let isExists = adoptions.filter(kPAPAdoptionAnimalIdKey)
                            if isExists.count > 0 {
                                if (adoptions.first?.animalUpdate)! == ((data as! NSDictionary)[kPAPAdoptionAnimalUpdateKey] as! Date)  {
                                    // do nothing...
                                } else {
                                    adoption.saveInBackground(block: { (success, error) in
                                        if (success) {
                                            print("save2")
                                            self.myAdoptionSaveToRealm(myAdoption: myAdoption, adoption: adoption)
                                        } else {
                                            print("error2")
                                        }
                                    })
                                }
                            } else {
                                adoption.saveInBackground(block: { (success, error) in
                                    if (success) {
                                        print("save3")
                                        self.myAdoptionSaveToRealm(myAdoption: myAdoption, adoption: adoption)
                                    } else {
                                        print("error3")
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
    }

    func myAdoptionSaveToRealm(myAdoption:Adoption ,adoption:PFObject) {
        myAdoption.albumFile        = adoption[kPAPAdoptionAlbumFileKey] as! String
        myAdoption.albumUpdate      = adoption[kPAPAdoptionAlbumUpdateKey] as! String
        myAdoption.animalAreaPkid   = adoption[kPAPAdoptionAnimalAreaPkidKey] as! Int
        myAdoption.animalBacterin   = adoption[kPAPAdoptionAnimalBacterinKey] as! String
        myAdoption.animalBodytype   = adoption[kPAPAdoptionAnimalBodytypeKey] as! String
        myAdoption.animalCaption    = adoption[kPAPAdoptionAnimalCaptionKey] as! String
        if (adoption[kPAPAdoptionAnimalCloseddateKey] != nil) {
            myAdoption.animalCloseddate     = adoption[kPAPAdoptionAnimalCloseddateKey] as! Date
        }
        myAdoption.animalColour     = adoption[kPAPAdoptionAnimalColourKey] as! String
        if (adoption[kPAPAdoptionAnimalCreatetimeKey] != nil) {
            myAdoption.animalCreatetime     = adoption[kPAPAdoptionAnimalCreatetimeKey] as! Date
        }
        myAdoption.animalFoundplace = adoption[kPAPAdoptionAnimalFoundplaceKey] as! String
        myAdoption.animalId         = adoption[kPAPAdoptionAnimalIdKey] as! Int
        myAdoption.animalKind       = adoption[kPAPAdoptionAnimalKindKey] as! String
        if (adoption[kPAPAdoptionAnimalOpendateKey] != nil) {
            myAdoption.animalOpendate     = adoption[kPAPAdoptionAnimalOpendateKey] as! Date
        }
        myAdoption.animalPlace      = adoption[kPAPAdoptionAnimalPlaceKey] as! String
        myAdoption.animalRemark     = adoption[kPAPAdoptionAnimalRemarkKey] as! String
        myAdoption.animalSex        = adoption[kPAPAdoptionAnimalSexKey] as! String
        myAdoption.animalShelterPkid = adoption[kPAPAdoptionAnimalShelterPkidKey] as! Int
        myAdoption.animalStatus     = adoption[kPAPAdoptionAnimalStatusKey] as! String
        myAdoption.animalSterilization = adoption[kPAPAdoptionAnimalSterilizationKey] as! String
        myAdoption.animalSubid      = adoption[kPAPAdoptionAnimalSubidKey] as! String
        myAdoption.animalTitle      = adoption[kPAPAdoptionAnimalTitleKey] as! String
        if (adoption[kPAPAdoptionAnimalUpdateKey] != nil) {
            myAdoption.animalUpdate     = adoption[kPAPAdoptionAnimalUpdateKey] as! Date
        }
        if (adoption[kPAPAdoptionCDateKey] != nil) {
            myAdoption.cDate            = adoption[kPAPAdoptionCDateKey] as! Date
        }
        myAdoption.shelterAddress   = adoption[kPAPAdoptionShelterAddressKey] as! String
        myAdoption.shelterName      = adoption[kPAPAdoptionShelterNameKey] as! String
        myAdoption.shelterTel       = adoption[kPAPAdoptionShelterTelKey] as! String
        myAdoption.createdAt        = adoption.createdAt!
        myAdoption.updateAt         = adoption.updatedAt!
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(myAdoption)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
