//
//  PAPConstants.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/7/25.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
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

// MARK: - Adoption Class
// Class key
let kPAPAdoptionClassKey            = "Adoption"
// Field keys
let kPAPAdoptionAlbumFileKey        = "albumFile"
let kPAPAdoptionAlbumUpdateKey      = "albumUpdate"
let kPAPAdoptionAnimalAreaPkidKey   = "animalAreaPkid"
let kPAPAdoptionAnimalBacterinKey   = "animalBacterin"
let kPAPAdoptionAnimalBodytypeKey   = "animalBodytype"
let kPAPAdoptionAnimalCaptionKey    = "animalCaption"
let kPAPAdoptionAnimalCloseddateKey = "animalCloseddate"
let kPAPAdoptionAnimalColourKey     = "animalColour"
let kPAPAdoptionAnimalCreatetimeKey = "animalCreatetime"
let kPAPAdoptionAnimalFoundplaceKey = "animalFoundplace"
let kPAPAdoptionAnimalIdKey         = "animalId"
let kPAPAdoptionAnimalKindKey       = "animalKind"
let kPAPAdoptionAnimalOpendateKey   = "animalOpendate"
let kPAPAdoptionAnimalPlaceKey      = "animalPlace"
let kPAPAdoptionAnimalRemarkKey     = "animalRemark"
let kPAPAdoptionAnimalSexKey        = "animalSex"
let kPAPAdoptionAnimalShelterPkidKey    = "animalShelterPkid"
let kPAPAdoptionAnimalStatusKey     = "animalStatus"
let kPAPAdoptionAnimalSterilizationKey  = "animalSterilization"
let kPAPAdoptionAnimalSubidKey      = "animalSubid"
let kPAPAdoptionAnimalTitleKey      = "animalTitle"
let kPAPAdoptionAnimalUpdateKey     = "animalUpdate"
let kPAPAdoptionCDateKey            = "cDate"
let kPAPAdoptionShelterAddressKey   = "shelterAddress"
let kPAPAdoptionShelterNameKey      = "shelterName"
let kPAPAdoptionShelterTelKey       = "shelterTel"
// Server keys
let kServerAdoptionAlbumFileKey        = "album_file"
let kServerAdoptionAlbumUpdateKey      = "album_update"
let kServerAdoptionAnimalAreaPkidKey   = "animal_area_pkid"
let kServerAdoptionAnimalBacterinKey   = "animal_bacterin"
let kServerAdoptionAnimalBodytypeKey   = "animal_bodytype"
let kServerAdoptionAnimalCaptionKey    = "animal_caption"
let kServerAdoptionAnimalCloseddateKey = "animal_closeddate"
let kServerAdoptionAnimalColourKey     = "animal_colour"
let kServerAdoptionAnimalCreatetimeKey = "animal_createtime"
let kServerAdoptionAnimalFoundplaceKey = "animal_foundplace"
let kServerAdoptionAnimalIdKey         = "animal_id"
let kServerAdoptionAnimalKindKey       = "animal_kind"
let kServerAdoptionAnimalOpendateKey   = "animal_opendate"
let kServerAdoptionAnimalPlaceKey      = "animal_place"
let kServerAdoptionAnimalRemarkKey     = "animal_remark"
let kServerAdoptionAnimalSexKey        = "animal_sex"
let kServerAdoptionAnimalShelterPkidKey    = "animal_shelter_pkid"
let kServerAdoptionAnimalStatusKey     = "animal_status"
let kServerAdoptionAnimalSterilizationKey  = "animal_sterilization"
let kServerAdoptionAnimalSubidKey      = "animal_subid"
let kServerAdoptionAnimalTitleKey      = "animal_title"
let kServerAdoptionAnimalUpdateKey     = "animal_update"
let kServerAdoptionCDateKey            = "cDate"
let kServerAdoptionShelterAddressKey   = "shelter_address"
let kServerAdoptionShelterNameKey      = "shelter_name"
let kServerAdoptionShelterTelKey       = "shelter_tel"
