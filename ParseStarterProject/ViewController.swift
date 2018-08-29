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
import ParseUI
import Alamofire
import RealmSwift
import AVFoundation
//import FBSDKCoreKit
//import FBSDKLoginKit

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
        PAPUtility.saveLocalInstagramPhotoAndVideo(aPath: "/lovelycatonline", toUserId: "Yb2F4PtVLX")
        
        // 檢查目前的登入狀態
//        if (FBSDKAccessToken.current() != nil) {
//            // User is Logged in, do work such as go to next view controller
//        } else {
//
//        }
        
        /*
         * Facebook 登入按鈕
         */
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile", "email"]
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
//        
//        let connection = FBSDKGraphRequestConnection()
//        connection.add(FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, group"])) { (request, object, error) in
//            print("request = \(String(describing: request)),\n Object = \(String(describing: object))\n error = \(String(describing: error))")
//        }
//        connection.start()
    }
    
    @IBAction func fbBtn(_ sender: Any) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("current User = \(String(describing: PFUser.current()))")
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
                        adoption[kPAPAdoptionAnimalAgeKey]  = (data as! NSDictionary)[kServerAdoptionAnimalAgeKey]
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
                            let isExists = adoptions.filter("\(kPAPAdoptionAnimalIdKey) == \(adoption[kPAPAdoptionAnimalIdKey]!)")
                            if isExists.count > 0 {
                                if (adoption[kPAPAdoptionAnimalUpdateKey] != nil) && (adoptions.first?.animalUpdate)! == (adoption[kPAPAdoptionAnimalUpdateKey] as! Date)  {
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
            15 - 2zHaP1o5g6 - 嘉義市流浪動物收容所
            48 - HcTtyduVbP - 基隆市寵物銀行
            49 - zPFJM8RQbn - 台北市動物之家
            50 - rkWNmdyM5B - 新北市板橋區公立動物之家
            51 - 63RrKDoSER - 新北市新店區公立動物之家
            53 - 69Kionba8D - 新北市中和區公立動物之家
            55 - OwZA5uB4RO - 新北市淡水區公立動物之家
            56 - 87BowA1EQ2 - 新北市瑞芳區公立動物之家
            58 - aS7SObCvlW - 新北市五股區公立動物之家
            59 - 4dksN7h80F - 新北市八里區公立動物之家
            60 - yljkAt3Gbe - 新北市三芝區公立動物之家
            61 - GB2B1xNpm0 - 桃園市動物保護教育園區
            62 - tJDLL6g4uQ - 新竹市動物收容所
            63 - VJhMHU51J3 - 新竹縣動物收容所
            67 - wUaB9nL7Bz - 台中市動物之家南屯園區
            68 - hrEHLELF3B - 台中市動物之家后里園區
            69 - dUiyYF2pYA - 彰化縣流浪狗中途之家
            70 - 9lWNmV7bkQ - 南投縣公立動物收容所
            71 - djT6DvtKe8 - 嘉義市流浪犬收容中心
            72 - lAUwi1nFdC - 嘉義縣流浪犬中途之家
            73 - 8uDIjfHzkU - 臺南市動物之家灣裡站
            74 - SvzOf7hh0H - 臺南市動物之家善化站
            75 - F1W8QxiIGh - 高雄市壽山動物保護教育園區
            76 - 5Cb3ZqFJCZ - 高雄市燕巢動物保護關愛園區
            77 - c0igVxnReJ - 屏東縣流浪動物收容所
            78 - tam4oxzKYQ - 宜蘭縣流浪動物中途之家
            79 - eW6jDwkf3g - 花蓮縣流浪犬中途之家
            80 - p3uG1ZFUg2 - 台東縣動物收容中心
            81 - hS7gxEtth6 - 連江縣流浪犬收容中心
            82 - YT9fOc95et - 金門縣動物收容中心
            83 - 9XUrkxAGGR - 澎湖縣流浪動物收容中心
            89 - xk74AdqNAn - 雲林縣流浪動物收容所
            92 - ZBqx2W6wZj - 新北市政府動物保護防疫處
            96 - FG2Jcj679Y - 苗栗縣生態保育教育中心
        */
        let fromShelterPkid = (fromData as! NSDictionary)[kServerAdoptionAnimalShelterPkidKey]! as! Int
        var postUser = PFUser()
        switch fromShelterPkid {
        case 15:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "2zHaP1o5g6")
        case 48:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "HcTtyduVbP")
        case 49:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "zPFJM8RQbn")
        case 50:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "rkWNmdyM5B")
        case 51:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "63RrKDoSER")
        case 53:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "69Kionba8D")
        case 55:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "OwZA5uB4RO")
        case 56:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "87BowA1EQ2")
        case 58:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "aS7SObCvlW")
        case 59:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "4dksN7h80F")
        case 60:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "yljkAt3Gbe")
        case 61:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "GB2B1xNpm0")
        case 62:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "tJDLL6g4uQ")
        case 63:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "VJhMHU51J3")
        case 67:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "wUaB9nL7Bz")
        case 68:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "hrEHLELF3B")
        case 69:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "dUiyYF2pYA")
        case 70:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "9lWNmV7bkQ")
        case 71:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "djT6DvtKe8")
        case 72:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "lAUwi1nFdC")
        case 73:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "8uDIjfHzkU")
        case 74:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "SvzOf7hh0H")
        case 75:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "F1W8QxiIGh")
        case 76:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "5Cb3ZqFJCZ")
        case 77:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "c0igVxnReJ")
        case 78:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "tam4oxzKYQ")
        case 79:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "eW6jDwkf3g")
        case 80:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "p3uG1ZFUg2")
        case 81:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "hS7gxEtth6")
        case 82:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "YT9fOc95et")
        case 83:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "9XUrkxAGGR")
        case 89:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "KWbmrqcVKb")
        case 92:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "ZBqx2W6wZj")
        case 96:
            postUser = PFUser(withoutDataWithClassName: "_User", objectId: "FG2Jcj679Y")
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
    @IBAction func loginButtonPressed(_ sender: Any) {
        let logInViewController = CustomLogInViewController()
        logInViewController.fields = [.default, .facebook, .dismissButton, .usernameAndPassword]
        logInViewController.delegate = self
        
        
        let signUpViewController = CustomSignUpViewController()
        signUpViewController.delegate = self
        signUpViewController.fields = .default
        
        logInViewController.signUpController = signUpViewController
        present(logInViewController, animated: true, completion: nil)
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        PFUser.logOut()
    }
}

extension ViewController : PFLogInViewControllerDelegate {
    func logInViewControllerDidCancelLog(in logInController: PFLogInViewController) {
        print("logInViewControllerDidCancelLog")
    }
    func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: Error?) {
        print("didFailToLogInWithError\(String(describing: error?.localizedDescription))")
    }
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        print("didLogin user=\(user)")
    }
}

extension ViewController : PFSignUpViewControllerDelegate {
    func signUpViewControllerDidCancelSignUp(_ signUpController: PFSignUpViewController) {
        print("signUpViewControllerDidCancelSignUp")
    }
    func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: Error?) {
        print("didFailToSignUpWithError\(String(describing: error?.localizedDescription))")
    }
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        print("didSignUp user=\(user)")
    }
}
