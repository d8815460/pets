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
import AVFoundation

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
        self.queryFromAdoption()


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
            path = path + "/lovelycatonline"
            let postUser = PFUser(withoutDataWithObjectId: "0cPtDCVYGY")  //這邊要依據每次爬蟲爬出來的結果，新建用戶並給予該用戶 objectId
            do{
                let fileList = try FileManager.default.contentsOfDirectory(atPath: path)

                for file in fileList{
                    let fileType = file.substring(from: file.index(file.endIndex, offsetBy: -3))
                    let userPhoto = PFObject(className:kPAPVideosClassKey)
                    let fileName = "\(path)/\(file)"
                    if fileType == "jpg" {
//                        let image = UIImage(named: fileName)
//                        let imageData = UIImagePNGRepresentation(image!)
//                        let imageFile = PFFile(name:file, data:imageData!)
//                        userPhoto[kPAPPetsImageFileKey] = imageFile
                    } else { // mp4
                        let fileData = try PFFile(name: file, contentsAtPath: fileName)
                        userPhoto[kPAPVideosVideoMp4Key] = fileData
                        userPhoto[kPAPVideosVideoKey] = fileData
                        userPhoto[kPAPVideosVideoAnimatedWebpKey] = fileData
                        let imageData = try PFFile(name: "image", data: UIImagePNGRepresentation(self.imageFromVideo(url: URL(fileURLWithPath: fileName), at: 0)!)!)!
                        userPhoto[kPAPVideosVideoThumbnailKey] = imageData
                        userPhoto[kPAPVideosVideoIdKey] = 0
//                        let size = self.resolutionSizeForLocalVideo(url: NSURL(string: fileName)!)
                        userPhoto[kPAPVideosVideoHeightKey] = 640
                        userPhoto[kPAPVideosVideoWidthKey]  = 640
                        userPhoto[kPAPVideosVideoRotationKey] = 0
                        userPhoto[kPAPVideosUserKey] = postUser
                        userPhoto[kPAPVideosVideoMimetypeKey] = "video/mp4"
                        userPhoto[kPAPVideosVideoDurationKey] = self.getMediaDuration(url: NSURL(fileURLWithPath: fileName))
                        userPhoto[kPAPVideosTitleKey]   = "社會貓"
                        userPhoto[kPAPVideosDescribeKey] = "這麼可愛的貓，你見過嗎？"
                        userPhoto[kPAPVideosUploadTimeKey] = 1524324670
                        userPhoto[kPAPVideosViewsKey] = 0
                        userPhoto[kPAPVideosUserIdKey] = 0
                        userPhoto.saveInBackground { (success, error) in
                            if success {
                                print("save success")
                            } else {
                                print("save error")
                            }
                        }

                    }
//                    userPhoto[kPAPPetsFileNameKey]  = file
//                    userPhoto[kPAPPetsTypeKey]      = fileType
//                    userPhoto[kPAPPetsUserKey]      = postUser
//                    userPhoto.saveInBackground { (success, error) in
//                        if success {
//                            print("save success")
//                        } else {
//                            print("save error")
//                        }
//                    }
                }
            }
            catch{
                print("Cannot list directory")
            }
        }
    }

    func imageFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return UIImage(cgImage: thumbnailImageRef)
    }

    func getMediaDuration(url: NSURL!) -> Float64{
        let asset : AVURLAsset = AVURLAsset(url: url as URL) as AVURLAsset
        let duration : CMTime = asset.duration
        return CMTimeGetSeconds(duration)
    }

    func resolutionSizeForLocalVideo(url:NSURL) -> CGSize? {

        let videoAsset: AVAsset = AVURLAsset(url: url as URL, options: nil)
        let videoTrack: AVAssetTrack? = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first
//        guard let track = AVURLAsset(url: url as URL).tracks(withMediaType: AVMediaTypeVideo).first else { return nil }
        let size = videoTrack?.naturalSize
        return CGSize(width: fabs((size?.width)!), height: fabs((size?.height)!))
    }

    func queryFromAdoption() {
        Alamofire.request("http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL").responseJSON { response in
            if response.result.isSuccess {
                // convert data to dictionary array
                let result:NSArray = response.value as! NSArray
                if result.count > 0 {
                    for data in result {

                        let postUser = self.getPFUser(fromData: data)

                        let adoption = PFObject(className: kPAPAdoptionClassKey)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        adoption[kPAPAdoptionAlbumFileKey] = (data as! NSDictionary)[kServerAdoptionAlbumFileKey]
                        adoption[kPAPAdoptionAlbumUpdateKey]  = (data as! NSDictionary)[kServerAdoptionAlbumUpdateKey]
                        adoption[kPAPAdoptionAnimalAreaPkidKey]  = (data as! NSDictionary)[kServerAdoptionAnimalAreaPkidKey]
                        adoption[kPAPAdoptionAnimalBacterinKey]  = (data as! NSDictionary)[kServerAdoptionAnimalBacterinKey]
                        adoption[kPAPAdoptionAnimalBodytypeKey]  = (data as! NSDictionary)[kServerAdoptionAnimalBodytypeKey]
                        adoption[kPAPAdoptionAnimalCaptionKey]  = (data as! NSDictionary)[kServerAdoptionAnimalCaptionKey]
                        adoption[kPAPAdoptionUserKey] = postUser
                        if ((data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey]! as! String) == "") { } else {
                            let animalCloseddate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalCloseddateKey]! as! String)
                            adoption[kPAPAdoptionAnimalCloseddateKey]  = animalCloseddate
                        }
                        adoption[kPAPAdoptionAnimalColourKey]  = (data as! NSDictionary)[kServerAdoptionAnimalColourKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey] == nil || ((data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey]! as! String) == "") { } else {
                            let animal_createtime = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalCreatetimeKey]! as! String)
                            adoption[kPAPAdoptionAnimalCreatetimeKey]  = animal_createtime
                        }
                        adoption[kPAPAdoptionAnimalFoundplaceKey]  = (data as! NSDictionary)[kServerAdoptionAnimalFoundplaceKey]
                        adoption[kPAPAdoptionAnimalIdKey]  = (data as! NSDictionary)[kServerAdoptionAnimalIdKey]
                        adoption[kPAPAdoptionAnimalKindKey]  = (data as! NSDictionary)[kServerAdoptionAnimalKindKey]
                        if ((data as! NSDictionary)[kServerAdoptionAnimalOpendateKey] == nil ||
                            ((data as! NSDictionary)[kServerAdoptionAnimalOpendateKey]! as! String) == "") { } else {
                            let animalOpendate = dateFormatter.date(from: (data as! NSDictionary)[kServerAdoptionAnimalOpendateKey]! as! String)
                            adoption[kPAPAdoptionAnimalOpendateKey]  = animalOpendate
                        }
                        adoption[kPAPAdoptionAnimalPlaceKey]  = (data as! NSDictionary)[kServerAdoptionAnimalPlaceKey]
                        adoption[kPAPAdoptionAnimalRemarkKey]  = (data as! NSDictionary)[kServerAdoptionAnimalRemarkKey]
                        adoption[kPAPAdoptionAnimalSexKey]  = (data as! NSDictionary)[kServerAdoptionAnimalSexKey]
                        adoption[kPAPAdoptionAnimalShelterPkidKey]  = (data as! NSDictionary)[kServerAdoptionAnimalShelterPkidKey]
                        adoption[kPAPAdoptionAnimalStatusKey]  = (data as! NSDictionary)[kServerAdoptionAnimalStatusKey]
                        adoption[kPAPAdoptionAnimalSterilizationKey]  = (data as! NSDictionary)[kServerAdoptionAnimalSterilizationKey]
                        adoption[kPAPAdoptionAnimalSubidKey]  = (data as! NSDictionary)[kServerAdoptionAnimalSubidKey]
                        adoption[kPAPAdoptionAnimalTitleKey]  = (data as! NSDictionary)[kServerAdoptionAnimalTitleKey]
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
                        adoption[kPAPAdoptionShelterAddressKey]  = (data as! NSDictionary)[kServerAdoptionShelterAddressKey]
                        adoption[kPAPAdoptionShelterNameKey]  = (data as! NSDictionary)[kServerAdoptionShelterNameKey]
                        adoption[kPAPAdoptionShelterTelKey]  = (data as! NSDictionary)[kServerAdoptionShelterTelKey]

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

    func getPFUser(fromData: Any) -> PFUser {
        /*
            15 - AVDfO8GBis - 嘉義市流浪動物收容所
            48 - qg125EkIgH - 基隆市寵物銀行
            49 - Ukm1DDhQKE - 台北市動物之家
            50 - 3YEziVdLxL - 新北市板橋區公立動物之家
            51 - 8OI8iAQ7N8 - 新北市新店區公立動物之家
            53 - qW5f2BtUl9 - 新北市中和區公立動物之家
            55 - tr4thsevfc - 新北市淡水區公立動物之家
            56 - xS9xrCnLIH - 新北市瑞芳區公立動物之家
            58 - 9tl715rJ0q - 新北市五股區公立動物之家
            59 - vake2sftFJ - 新北市八里區公立動物之家
            60 - 1UZDpUrpLV - 新北市三芝區公立動物之家
            61 - 6CXnX5di5a - 桃園市動物保護教育園區
            62 - ZBqzs5aXGp - 新竹市動物收容所
            63 - iZJVVyDB7C - 新竹縣動物收容所
            67 - ANpBa1nFHS - 台中市動物之家南屯園區
            68 - XseaFJdXIH - 台中市動物之家后里園區
            69 - rYtTn0wMm2 - 彰化縣流浪狗中途之家
            70 - ldv3sNCDpE - 南投縣公立動物收容所
            71 - jBt35cQoRD - 嘉義市流浪犬收容中心
            72 - Au3sH1YMfo - 嘉義縣流浪犬中途之家
            73 - sIK13WZL8L - 臺南市動物之家灣裡站
            74 - 8bRh5TzHFr - 臺南市動物之家善化站
            75 - CjeZFL1ovZ - 高雄市壽山動物保護教育園區
            76 - 8N504cZqtT - 高雄市燕巢動物保護關愛園區
            77 - TBFLHWoYOH - 屏東縣流浪動物收容所
            78 - qSNUr1VvAv - 宜蘭縣流浪動物中途之家
            79 - oDKoDK3iHn - 花蓮縣流浪犬中途之家
            80 - baGfNu5UuU - 台東縣動物收容中心
            81 - 0gpmNcE6cg - 連江縣流浪犬收容中心
            82 - iDO5oaJdxI - 金門縣動物收容中心
            83 - AdvFOi6ZAn - 澎湖縣流浪動物收容中心
            89 - xk74AdqNAn - 雲林縣流浪動物收容所
            92 - Z35xFKjQz4 - 新北市政府動物保護防疫處
            96 - yBkBPWItFA - 苗栗縣生態保育教育中心
        */
        let fromShelterPkid = (fromData as! NSDictionary)[kServerAdoptionAnimalShelterPkidKey]! as! Int
        var postUser = PFUser()
        switch fromShelterPkid {
        case 15:
            postUser = PFUser(withoutDataWithObjectId: "AVDfO8GBis")
//            postUser.username = "嘉義市流浪動物收容所"
//            postUser.setValue(15, forKey: kPAPUserAnimalAreaPkidKey)
        case 48:
            postUser = PFUser(withoutDataWithObjectId: "qg125EkIgH")
//            postUser.username = "基隆市寵物銀行"
//            postUser.setValue(48, forKey: kPAPUserAnimalAreaPkidKey)
        case 49:
            postUser = PFUser(withoutDataWithObjectId: "Ukm1DDhQKE")
//            postUser.username = "台北市動物之家"
//            postUser.setValue(49, forKey: kPAPUserAnimalAreaPkidKey)
        case 50:
            postUser = PFUser(withoutDataWithObjectId: "3YEziVdLxL")
//            postUser.username = "新北市板橋區公立動物之家"
//            postUser.setValue(50, forKey: kPAPUserAnimalAreaPkidKey)
        case 51:
            postUser = PFUser(withoutDataWithObjectId: "8OI8iAQ7N8")
//            postUser.username = "新北市新店區公立動物之家"
//            postUser.setValue(51, forKey: kPAPUserAnimalAreaPkidKey)
        case 53:
            postUser = PFUser(withoutDataWithObjectId: "qW5f2BtUl9")
//            postUser.username = "新北市中和區公立動物之家"
//            postUser.setValue(53, forKey: kPAPUserAnimalAreaPkidKey)
        case 55:
            postUser = PFUser(withoutDataWithObjectId: "tr4thsevfc")
//            postUser.username = "新北市淡水區公立動物之家"
//            postUser.setValue(55, forKey: kPAPUserAnimalAreaPkidKey)
        case 56:
            postUser = PFUser(withoutDataWithObjectId: "xS9xrCnLIH")
//            postUser.username = "新北市瑞芳區公立動物之家"
//            postUser.setValue(56, forKey: kPAPUserAnimalAreaPkidKey)
        case 58:
            postUser = PFUser(withoutDataWithObjectId: "9tl715rJ0q")
//            postUser.username = "新北市五股區公立動物之家"
//            postUser.setValue(58, forKey: kPAPUserAnimalAreaPkidKey)
        case 59:
            postUser = PFUser(withoutDataWithObjectId: "vake2sftFJ")
//            postUser.username = "新北市八里區公立動物之家"
//            postUser.setValue(59, forKey: kPAPUserAnimalAreaPkidKey)
        case 60:
            postUser = PFUser(withoutDataWithObjectId: "1UZDpUrpLV")
//            postUser.username = "新北市三芝區公立動物之家"
//            postUser.setValue(60, forKey: kPAPUserAnimalAreaPkidKey)
        case 61:
            postUser = PFUser(withoutDataWithObjectId: "6CXnX5di5a")
//            postUser.username = "桃園市動物保護教育園區"
//            postUser.setValue(61, forKey: kPAPUserAnimalAreaPkidKey)
        case 62:
            postUser = PFUser(withoutDataWithObjectId: "ZBqzs5aXGp")
//            postUser.username = "新竹市動物收容所"
//            postUser.setValue(62, forKey: kPAPUserAnimalAreaPkidKey)
        case 63:
            postUser = PFUser(withoutDataWithObjectId: "iZJVVyDB7C")
//            postUser.username = "新竹縣動物收容所"
//            postUser.setValue(63, forKey: kPAPUserAnimalAreaPkidKey)
        case 67:
            postUser = PFUser(withoutDataWithObjectId: "ANpBa1nFHS")
//            postUser.username = "台中市動物之家南屯園區"
//            postUser.setValue(67, forKey: kPAPUserAnimalAreaPkidKey)
        case 68:
            postUser = PFUser(withoutDataWithObjectId: "XseaFJdXIH")
//            postUser.username = "台中市動物之家后里園區"
//            postUser.setValue(68, forKey: kPAPUserAnimalAreaPkidKey)
        case 69:
            postUser = PFUser(withoutDataWithObjectId: "rYtTn0wMm2")
//            postUser.username = "彰化縣流浪狗中途之家"
//            postUser.setValue(69, forKey: kPAPUserAnimalAreaPkidKey)
        case 70:
            postUser = PFUser(withoutDataWithObjectId: "ldv3sNCDpE")
//            postUser.username = "南投縣公立動物收容所"
//            postUser.setValue(70, forKey: kPAPUserAnimalAreaPkidKey)
        case 71:
            postUser = PFUser(withoutDataWithObjectId: "jBt35cQoRD")
//            postUser.username = "嘉義市流浪犬收容中心"
//            postUser.setValue(71, forKey: kPAPUserAnimalAreaPkidKey)
        case 72:
            postUser = PFUser(withoutDataWithObjectId: "Au3sH1YMfo")
//            postUser.username = "嘉義縣流浪犬中途之家"
//            postUser.setValue(72, forKey: kPAPUserAnimalAreaPkidKey)
        case 73:
            postUser = PFUser(withoutDataWithObjectId: "sIK13WZL8L")
//            postUser.username = "臺南市動物之家灣裡站"
//            postUser.setValue(73, forKey: kPAPUserAnimalAreaPkidKey)
        case 74:
            postUser = PFUser(withoutDataWithObjectId: "8bRh5TzHFr")
//            postUser.username = "臺南市動物之家善化站"
//            postUser.setValue(74, forKey: kPAPUserAnimalAreaPkidKey)
        case 75:
            postUser = PFUser(withoutDataWithObjectId: "CjeZFL1ovZ")
//            postUser.username = "高雄市壽山動物保護教育園區"
//            postUser.setValue(75, forKey: kPAPUserAnimalAreaPkidKey)
        case 76:
            postUser = PFUser(withoutDataWithObjectId: "8N504cZqtT")
//            postUser.username = "高雄市燕巢動物保護關愛園區"
//            postUser.setValue(76, forKey: kPAPUserAnimalAreaPkidKey)
        case 77:
            postUser = PFUser(withoutDataWithObjectId: "TBFLHWoYOH")
//            postUser.username = "屏東縣流浪動物收容所"
//            postUser.setValue(77, forKey: kPAPUserAnimalAreaPkidKey)
        case 78:
            postUser = PFUser(withoutDataWithObjectId: "qSNUr1VvAv")
//            postUser.username = "宜蘭縣流浪動物中途之家"
//            postUser.setValue(78, forKey: kPAPUserAnimalAreaPkidKey)
        case 79:
            postUser = PFUser(withoutDataWithObjectId: "oDKoDK3iHn")
//            postUser.username = "花蓮縣流浪犬中途之家"
//            postUser.setValue(79, forKey: kPAPUserAnimalAreaPkidKey)
        case 80:
            postUser = PFUser(withoutDataWithObjectId: "baGfNu5UuU")
//            postUser.username = "台東縣動物收容中心"
//            postUser.setValue(80, forKey: kPAPUserAnimalAreaPkidKey)
        case 81:
            postUser = PFUser(withoutDataWithObjectId: "0gpmNcE6cg")
//            postUser.username = "連江縣流浪犬收容中心"
//            postUser.setValue(81, forKey: kPAPUserAnimalAreaPkidKey)
        case 82:
            postUser = PFUser(withoutDataWithObjectId: "iDO5oaJdxI")
//            postUser.username = "金門縣動物收容中心"
//            postUser.setValue(82, forKey: kPAPUserAnimalAreaPkidKey)
        case 83:
            postUser = PFUser(withoutDataWithObjectId: "AdvFOi6ZAn")
//            postUser.username = "澎湖縣流浪動物收容中心"
//            postUser.setValue(83, forKey: kPAPUserAnimalAreaPkidKey)
        case 89:
            postUser = PFUser(withoutDataWithObjectId: "xk74AdqNAn")
//            postUser.username = "雲林縣流浪動物收容所"
//            postUser.setValue(89, forKey: kPAPUserAnimalAreaPkidKey)
        case 92:
            postUser = PFUser(withoutDataWithObjectId: "Z35xFKjQz4")
//            postUser.username = "新北市政府動物保護防疫處"
//            postUser.setValue(92, forKey: kPAPUserAnimalAreaPkidKey)
        case 96:
            postUser = PFUser(withoutDataWithObjectId: "yBkBPWItFA")
//            postUser.username = "苗栗縣生態保育教育中心"
//            postUser.setValue(96, forKey: kPAPUserAnimalAreaPkidKey)
        default:
            postUser = PFUser()
        }
        if postUser.isNew {

        } else {
            self.savePFUserToRealm(postUser: postUser)
        }

        return postUser
    }

    

    func savePFUserToRealm(postUser:PFUser) {
        // Get the default Realm
        let realm = try! Realm()
        let users = realm.objects(pUser.self).filter("objectId = '\(postUser.objectId!)'")
        if users.count > 0 {
            // 本機已經有該用戶
            return
        } else {
            // 本機沒有該用戶
            let user:pUser = pUser()
            user.objectId = postUser.objectId!
//            user.username = postUser.username!
//            user.animalAreaPkid = postUser.object(forKey: kPAPUserAnimalAreaPkidKey) as! Int
            // Get the default Realm
            let realm = try! Realm()
            // Persist your data easily
            try! realm.write {
                realm.add(user)
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
