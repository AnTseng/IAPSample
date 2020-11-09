//
//  AppDelegate.swift
//  IAPSample
//
//  Created by Ann on 2020/11/9.
//

import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 使用者買東西時有可能突然沒有網路，造成交易無法順序完成。因此若我們在 App 啟動時將 IAPManager 設為 SKPaymentQueue 的 observer，下次使用者啟動 App 時 IAPManager 將可馬上收到通知，觸發 SKPaymentTransactionObserver 的 function，順利完成之前未完的交易。
        SKPaymentQueue.default().add(IAPManager.shared)
        return true
    }

    // MARK: UISceneSession Lifecycle

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

