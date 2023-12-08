//
//  AppDelegate.swift
//  Todoey
//
//  Created by 홍진표 on 12/1/23.
//

import UIKit
import CoreData

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
    
    // MARK: - Core Data stack

    /// Initialize a Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        /// `NSPersistentContainer:` A container that encapsulates the Core Data stack in your app.
        
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error: NSError = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext() -> Void {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror: NSError = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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

