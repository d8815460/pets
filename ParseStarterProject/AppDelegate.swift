/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import UserNotifications

import Parse
import Alamofire
import Realm
import RealmSwift
import ESTabBarController_swift

// If you want to use any of the UI components, uncomment this line
// import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var window: UIWindow?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ****************************************************************************
        // Initialize Parse SDK
        // ****************************************************************************

        let configuration = ParseClientConfiguration {
            // Add your Parse applicationId:
            $0.applicationId = "uaWmegNxLPOyxUPd9CJ8LE1JhsUzY397jTrdPsP5"
            // Uncomment and add your clientKey (it's not required if you are using Parse Server):
            $0.clientKey = "haWnX2ytk17WYCc371wLpoPInz45jXs9rT3dbIPP"

            // Uncomment the following line and change to your Parse Server address;
            $0.server = "https://pg-app-r64i9odpwyu4tcdv4rzf0cv5tp1yyw.scalabl.cloud/1/"

            // Enable storing and querying data from Local Datastore.
            // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)

        // ****************************************************************************
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL()

        // If you would like all objects to be private by default, remove this line.
        defaultACL.hasPublicReadAccess = true

        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let oldPushHandlerOnly = !responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] == nil
            }
            if oldPushHandlerOnly || noPushPayload {
                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let tabBarController = storyboard.instantiateViewController(withIdentifier: "tab") as! ESTabBarController
        tabBarController.delegate = self
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
                    let imagePicker =  UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    self.window?.rootViewController?.present(imagePicker, animated: true, completion: {

                    })
                })
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: { (action) in
                    let imagePicker =  UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    self.window?.rootViewController?.present(imagePicker, animated: true, completion: {

                    })
                })
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                tabBarController?.present(alertController, animated: true, completion: nil)
            }
        }

        let v1 = storyboard.instantiateViewController(withIdentifier: "ai") as! UINavigationController
        let v2 = storyboard.instantiateViewController(withIdentifier: "pet") as! UINavigationController
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()

        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Leader", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Setting", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        tabBarController.tabBar.barTintColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        self.window?.rootViewController = tabBarController
        if #available(iOS 10.0, *) {
            // iOS 10+
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                print("Notifications access granted: \(granted.description)")
            }
            application.registerForRemoteNotifications()
        } else {
            // iOS 8, 9
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }

        return true
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()

        PFPush.subscribeToChannel(inBackground: "") { succeeded, error in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n")
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error!)
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PFPush.handle(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }

    //--------------------------------------
    // MARK: Image Picker Delegate
    //--------------------------------------

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImagePNGRepresentation(image!)
        let strBase64 = imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

        let photodic = ["image":strBase64]
        Alamofire.request("https://localhost:8888/post", method: .post)

        let photoObject = PFObject(className: "Pets")
        let imageFile = PFFile(name: "image.png", data: imageData!)
        photoObject.add(imageFile!, forKey: "imageFile")
        photoObject.saveEventually { (success, error) in
            if error == nil {
                print("success save")
            } else {
                print("something error")
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}
