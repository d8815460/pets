//
//  AdoptionDetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/8/5.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import Parse

class AdoptionDetailViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet var shelterName: UILabel!
    @IBOutlet var contentTextView: UITextView!

    public var adoptionObject: PFObject! {
        didSet {
            let sex:String? = adoptionObject![kPAPAdoptionAnimalSexKey]! as? String
            if sex == "M" { navigationTitle.text = "我是帥哥" } else if sex == "F" { navigationTitle.text = "我是美女" } else { navigationTitle.text = "為輸入性別"}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let name:String! = adoptionObject![kPAPAdoptionShelterNameKey]! as? String
        if shelterName != nil {
            shelterName.text = name
        }

        /*
         類型：kPAPAdoptionAnimalKindKey
         所在地：kPAPAdoptionAnimalFoundplaceKey
         性別：kPAPAdoptionAnimalSexKey
         年齡：kPAPAdoptionAnimalAgeKey
         體型：kPAPAdoptionAnimalBodytypeKey
         毛色：kPAPAdoptionAnimalColourKey
         結紮：kPAPAdoptionAnimalSterilizationKey
         區域編碼：kPAPAdoptionAnimalSubidKey
         描述：kPAPAdoptionAnimalCaptionKey
         所屬單位：kPAPAdoptionAnimalPlaceKey
         地址：kPAPAdoptionShelterAddressKey
         電話：kPAPAdoptionShelterTelKey
         注意事項：因資料維護由各收容所負責，前往收容所前，請先打電話詢問此編號是否存在
         */
        var sex:String? = adoptionObject![kPAPAdoptionAnimalSexKey]! as? String
        if sex == "M" { sex = "我是帥哥" } else if sex == "F" { sex = "我是美女" } else { sex = "未輸入"}

        var size:String? = adoptionObject![kPAPAdoptionAnimalBodytypeKey]! as? String
        if size == "MINI" {
            size = "迷你"
        } else if size == "SMALL" {
            size = "小型"
        } else if size == "MEDIUM" {
            size = "中型"
        } else if size == "BIG" {
            size = "大型"
        }

        var sterilization:String? = adoptionObject![kPAPAdoptionAnimalSterilizationKey]! as? String
        if sterilization == "T" {
            sterilization = "是"
        } else if sterilization == "F" {
            sterilization = "否"
        } else if sterilization == "N" {
            sterilization = "未輸入"
        }

        var age:String? = adoptionObject![kPAPAdoptionAnimalAgeKey]! as? String
        if age == "CHILD" {
            age = "幼年"
        } else if age == "ADULT" {
            age = "成年"
        }

        let content = "類型：\(String(describing: adoptionObject?[kPAPAdoptionAnimalKindKey] as! String))\n\n尋獲地：\(String(describing: adoptionObject?[kPAPAdoptionAnimalFoundplaceKey] as! String))\n\n性別：\(String(describing: sex!))\n\n年齡：\(String(describing: age!))\n\n體型：\(String(describing: size!))\n\n毛色：\(String(describing: adoptionObject?[kPAPAdoptionAnimalColourKey] as! String))\n\n結紮：\(String(describing: sterilization!))\n\n區域編號：\(String(describing: adoptionObject?[kPAPAdoptionAnimalSubidKey] as! String))\n\n描述：\(String(describing: adoptionObject?[kPAPAdoptionAnimalCaptionKey] as! String))\n\n所屬單位：\(String(describing: adoptionObject?[kPAPAdoptionAnimalPlaceKey] as! String))\n\n地址：\(String(describing: adoptionObject?[kPAPAdoptionShelterAddressKey] as! String))\n\n電話：\(String(describing: adoptionObject?[kPAPAdoptionShelterTelKey]! as! String))\n\n注意事項：因資料維護由各收容所負責，前往收容所前，請先打電話詢問此編號是否存在"
        contentTextView.text = content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
