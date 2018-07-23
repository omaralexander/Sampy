//
//  AppDelegate.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import GooglePlaces
import Fabric
import Crashlytics
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let gcmMessageText = "gcm.message_text"
    var usersLoginToken = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
        currentUser?.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
                // Handle error
                print(error.localizedDescription)
                return;
            }
            self.usersLoginToken = idToken!
            print(self.usersLoginToken)
            }
        }
        
        GMSPlacesClient.provideAPIKey("AIzaSyBmVRWE6ap8CIS0xVlTzGT3Ya50vHuEHdM")
        // FIRDatabase.database().persistenceEnabled = true
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
                    }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .InstanceIDTokenRefresh  ,
                                               object: nil)
       Fabric.with([Crashlytics.self])
        
      
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("This is the error that appeared when trying to prompt user for remotenotifications\(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
        }
    
        // Print full message.
        print(userInfo)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            
            // Connect to FCM since connection may have failed when attempted before having a token.
        }
            connectToFcm()
        
    }
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
               
                guard let refreshedTokenUpHere = InstanceID.instanceID().token() else {
                    return
                }
                
                let uid = Auth.auth().currentUser?.uid
                if uid == nil {
                    
                }else{
                   
                    Database.database().reference().child("Users").child(uid!).updateChildValues(["token":refreshedTokenUpHere as String])
                }
            }
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
            }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
           }

    func applicationWillTerminate(_ application: UIApplication) {
        }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
           
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option

        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
           
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        if let refreshedToken = InstanceID.instanceID().token() {
            
            // Connect to FCM since connection may have failed when attempted before having a token.
        }
        connectToFcm()
        
    }
}


