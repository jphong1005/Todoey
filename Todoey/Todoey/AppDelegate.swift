//
//  AppDelegate.swift
//  Todoey
//
//  Created by 홍진표 on 12/1/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    // MARK: - Process Lifecycle
    /// 프로세스 레벨 수준의 이벤트를 애플리케이션에 알림.
    /// 따라서 시스템은 프로세스가 시작되거나 종료될 때 AppDelegate에 알림.
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        /// App이 실행될 것임을 알리고 초기 설정을 수행하는 단계
        /// App이 시작되기 전에 호출
        print("AppDelegate: Process Lifecycle - willFinishLaunchingWithOptions")
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /// App이 실행되고 초기 설정이 완료된 후 호출
        /// 이 시점에서 App이 화면에 나타나기 직전 단계
        print("AppDelegate: Process Lifecycle - didFinishLaunchingWithOptions")
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        /// App이 종료되기 직전에 호출
        /// (-> App이 정상적으로 종료될 때만 호출되며, Background에서 종료되는 경우는 호출되지 않음)
        print("AppDelegate: Process Lifecycle - applicationWillTerminate")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        print("configurationForConnecting")
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

