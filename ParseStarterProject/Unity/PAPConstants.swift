//
//  PAPConstants.swift
//  ParseStarterProject-Swift
//
//  Created by 陳駿逸 on 2018/7/25.
//  Copyright © 2018年 Parse. All rights reserved.
//

import UIKit
import RealmSwift

let kPAPParseAPIUrlKey              = "https://pg-app-ambcidt2nw8v4pyzpddxcwf9s6ev18.scalabl.cloud/1/"
let kPAPApplicationIdKey            = "XcQ0KKdcEpvKaqHMXT4Xyrk0cBLFQfM69Um5hgP6"
let kPAPClientKey                   = "Ysx7fcKDt25W1oXePkstB4aZhUciUPFQ6frk9oBM"

let kPAPPetsLoadObjectsPerPage:UInt = 30

// MARK: - Adoption Object
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

// User for Realm
class pUser: Object {
    @objc dynamic var username = ""
    @objc dynamic var objectId = ""
    @objc dynamic var animalAreaPkid = 0
}

// MARK: - Videos Object

class Video: Object {
    @objc dynamic var objectId              = ""
    @objc dynamic var fileName              = ""
    @objc dynamic var user:pUser?           = nil
    @objc dynamic var video_width           = 0.0
    @objc dynamic var video_height          = 0.0
    @objc dynamic var video_rotation        = 0.0
    @objc dynamic var video_thumbnail       = Data()
    @objc dynamic var describe              = ""
    @objc dynamic var video_mp4             = Data()
    @objc dynamic var views                 = 0
    @objc dynamic var video_mimetype        = ""
    @objc dynamic var video_animated_webp   = Data()
    @objc dynamic var video_duration        = 0.0
    @objc dynamic var title                 = ""
}

// MARK: - User Class
// Class key
let kPAPUserClassKey                        = "_User"
// Field keys
let kPAPUserInstagramUrlKey                 = "instagramUrl"
let kPAPUserPicSmallKey                     = "thumbnailPic"
let kPAPUserPicMediumKey                    = "mediumPic"
let kPAPUserAnimalAreaPkidKey               = "animalAreaPkid"


// MARK: - Videos Class
// Class key
let kPAPVideosClassKey                      = "Videos"
// Field keys
let kPAPVideosVideoHeightKey                = "video_height"
let kPAPVideosVideoWidthKey                 = "video_width"
let kPAPVideosVideoRotationKey              = "video_rotation"
let kPAPVideosVideoMimetypeKey              = "video_mimetype"
let kPAPVideosVideoDurationKey              = "video_duration"
let kPAPVideosTitleKey                      = "title"
let kPAPVideosDescribeKey                   = "describe"
let kPAPVideosPubTimeKey                    = "pub_time"
let kPAPVideosViewsKey                      = "views"
let kPAPVideosCommentStatusKey              = "comment_status"
let kPAPVideosStatusKey                     = "status"
let kPAPVideosVideoOggKey                   = "video_ogg"
let kPAPVideosUserKey                       = "user"
let kPAPVideosVideoGifKey                   = "video_gif"
let kPAPVideosVideoThumbnailKey             = "video_thumbnail"
let kPAPVideosVideoAnimatedWebpKey          = "video_animated_webp"
let kPAPVideosVideoMp4Key                   = "video_mp4"
let kPAPVideosFileNameKey                   = "fileName"
let kPAPVideosTypeImageKey                  = "image/jpg"
let kPAPVideosTypeVideoKey                  = "video/mp4"

// MARK: - Adoption Class
// Class key
let kPAPAdoptionClassKey                    = "Adoption"
// Field keys
let kPAPAdoptionAlbumFileKey                = "albumFile"
let kPAPAdoptionAlbumUpdateKey              = "albumUpdate"
let kPAPAdoptionAnimalAreaPkidKey           = "animalAreaPkid"
let kPAPAdoptionAnimalBacterinKey           = "animalBacterin"
let kPAPAdoptionAnimalBodytypeKey           = "animalBodytype"
let kPAPAdoptionAnimalCaptionKey            = "animalCaption"
let kPAPAdoptionAnimalCloseddateKey         = "animalCloseddate"
let kPAPAdoptionAnimalColourKey             = "animalColour"
let kPAPAdoptionAnimalCreatetimeKey         = "animalCreatetime"
let kPAPAdoptionAnimalFoundplaceKey         = "animalFoundplace"
let kPAPAdoptionAnimalIdKey                 = "animalId"
let kPAPAdoptionAnimalKindKey               = "animalKind"
let kPAPAdoptionAnimalOpendateKey           = "animalOpendate"
let kPAPAdoptionAnimalPlaceKey              = "animalPlace"
let kPAPAdoptionAnimalRemarkKey             = "animalRemark"
let kPAPAdoptionAnimalSexKey                = "animalSex"
let kPAPAdoptionAnimalShelterPkidKey        = "animalShelterPkid"
let kPAPAdoptionAnimalStatusKey             = "animalStatus"
let kPAPAdoptionAnimalSterilizationKey      = "animalSterilization"
let kPAPAdoptionAnimalSubidKey              = "animalSubid"
let kPAPAdoptionAnimalTitleKey              = "animalTitle"
let kPAPAdoptionAnimalUpdateKey             = "animalUpdate"
let kPAPAdoptionCDateKey                    = "cDate"
let kPAPAdoptionShelterAddressKey           = "shelterAddress"
let kPAPAdoptionShelterNameKey              = "shelterName"
let kPAPAdoptionShelterTelKey               = "shelterTel"
let kPAPAdoptionUserKey                     = "user"
let kPAPAdoptionAnimalAgeKey                = "animalAge"

// Server keys
let kServerAdoptionAlbumFileKey             = "album_file"
let kServerAdoptionAlbumUpdateKey           = "album_update"
let kServerAdoptionAnimalAreaPkidKey        = "animal_area_pkid"
let kServerAdoptionAnimalBacterinKey        = "animal_bacterin"
let kServerAdoptionAnimalBodytypeKey        = "animal_bodytype"
let kServerAdoptionAnimalCaptionKey         = "animal_caption"
let kServerAdoptionAnimalCloseddateKey      = "animal_closeddate"
let kServerAdoptionAnimalColourKey          = "animal_colour"
let kServerAdoptionAnimalCreatetimeKey      = "animal_createtime"
let kServerAdoptionAnimalFoundplaceKey      = "animal_foundplace"
let kServerAdoptionAnimalIdKey              = "animal_id"
let kServerAdoptionAnimalKindKey            = "animal_kind"
let kServerAdoptionAnimalOpendateKey        = "animal_opendate"
let kServerAdoptionAnimalPlaceKey           = "animal_place"
let kServerAdoptionAnimalRemarkKey          = "animal_remark"
let kServerAdoptionAnimalSexKey             = "animal_sex"
let kServerAdoptionAnimalShelterPkidKey     = "animal_shelter_pkid"
let kServerAdoptionAnimalStatusKey          = "animal_status"
let kServerAdoptionAnimalSterilizationKey   = "animal_sterilization"
let kServerAdoptionAnimalSubidKey           = "animal_subid"
let kServerAdoptionAnimalTitleKey           = "animal_title"
let kServerAdoptionAnimalUpdateKey          = "animal_update"
let kServerAdoptionCDateKey                 = "cDate"
let kServerAdoptionShelterAddressKey        = "shelter_address"
let kServerAdoptionShelterNameKey           = "shelter_name"
let kServerAdoptionShelterTelKey            = "shelter_tel"
let kServerAdoptionAnimalAgeKey             = "animal_age"

// MARK:- Activity Class
// Class key
let kPAPActivityClassKey        = "Activity"

// Field keys
let kPAPActivityTypeKey         = "type"
let kPAPActivityFromUserKey     = "fromUser"
let kPAPActivityToUserKey       = "toUser"
let kPAPActivityContentKey      = "content"
let kPAPActivityAdoptionKey     = "adoption"
let kPAPActivityPhotoKey        = "photo"

// Type values
let kPAPActivityTypeLike        = "like"
let kPAPActivityTypeFollow      = "follow"
let kPAPActivityTypeComment     = "comment"
let kPAPActivityTypeJoined      = "joined"

// MARK:- Cached Adoption Attributes
// keys
let kPAPAdoptionAttributesIsLikedByCurrentUserKey = "isLikedByCurrentUser";
let kPAPAdoptionAttributesLikeCountKey            = "likeCount"
let kPAPAdoptionAttributesLikersKey               = "likers"
let kPAPAdoptionAttributesCommentCountKey         = "commentCount"
let kPAPAdoptionAttributesCommentersKey           = "commenters"

// MARK:- Cached User Attributes
// keys
let kPAPUserAttributesAdoptionCountKey              = "adoptionCount"
let kPAPUserAttributesIsFollowedByCurrentUserKey    = "isFollowedByCurrentUser"

// MARK:- User Info Keys
let PAPAdoptionDetailsViewControllerUserLikedUnlikedAdoptionNotificationUserInfoLikedKey = "liked"
let kPAPEditAdoptionViewControllerUserInfoCommentKey = "comment"


// MARK:- NSNotification

let PAPAppDelegateApplicationDidReceiveRemoteNotification               = "com.parse.Anypic.appDelegate.applicationDidReceiveRemoteNotification"
let PAPUtilityUserFollowingChangedNotification                          = "com.parse.Anypic.utility.userFollowingChanged"
let PAPUtilityUserLikedUnlikedAdoptionCallbackFinishedNotification      = "com.parse.Anypic.utility.userLikedUnlikedAdoptionCallbackFinished"
let PAPUtilityDidFinishProcessingProfilePictureNotification             = "com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification"
let PAPTabBarControllerDidFinishEditingAdoptionNotification             = "com.parse.Anypic.tabBarController.didFinishEditingAdoption"
let PAPTabBarControllerDidFinishImageFileUploadNotification             = "com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification"
let PAPAdoptionDetailsViewControllerUserDeletedAdoptionNotification       = "com.parse.Anypic.adoptionDetailsViewController.userDeletedAdoption"
let PAPAdoptionDetailsViewControllerUserLikedUnlikedAdoptionNotification  = "com.parse.Anypic.adoptionDetailsViewController.userLikedUnlikedAdoptionInDetailsViewNotification"
let PAPAdoptionDetailsViewControllerUserCommentedOnAdoptionNotification   = "com.parse.Anypic.adoptionDetailsViewController.userCommentedOnAdoptionInDetailsViewNotification"


