//
//  AppDelegate.swift
//  GizoSDKExample
//
//  Created by Mahyar on 2023/12/19.
//

import UIKit
import GizoSDK
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initialieGizoSDK(launchOptions: launchOptions)
        return true
    }
    
    
    func initialieGizoSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        let result = Gizo.shared.initialize(options: GizoOptions(), launchOptions: launchOptions)
        Gizo.shared.setToken(clientId: "<clientId>", clientSecret: "<clientSecret>")
        
        if result.isSuccessful {
            print("[GizoSDK]: Initialization successful")
            
            Task {
                
                var userId:Int64? = 0
                if userId == nil
                {
                    let userId = await Gizo.shared.createUser()
                    if let userId = userId
                    {
                        let status = await Gizo.shared.setUserId(userId: userId)
                        print(status)
                    }
                }
                else
                {
                    let status = await Gizo.shared.setUserId(userId: userId!)
                    print(status)
                }
            }
            
        } else {
            print("[GizoSDK]: Initialization failed, reason: \(result.failure.debugDescription)")
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

