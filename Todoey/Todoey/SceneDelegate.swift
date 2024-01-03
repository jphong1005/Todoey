//
//  SceneDelegate.swift
//  Todoey
//
//  Created by 홍진표 on 12/1/23.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // MARK: - Property
    private let realmManager: RealmManager = RealmManager.shared


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        print("(scene) willConnectToSession")
        
        /// Initialization Realm
        realmManager.realm
        
        /// Realm File Path
        print(realmManager.realmFilePath)
        
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window = UIWindow(frame: UIScreen().bounds)
        
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: CategoryViewController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        print("sceneDidDisconnect")
    }
    
    // MARK: - UI Lifecycle
    /// 애플리케이션에 UI 상태를 알림.
    /// 따라서 포그라운드로 진입했다가 활성 상태로 전환하는 등의 일부 방법을 통해 시스템은 사용자의 UI 상태를 알림.

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        /// Scene이 활성화되어 사용자와 상호 작용할 수 있는 상태로 전환될 때 호출
        
        print("SceneDelegate: UI Lifecycle - sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        /// Scene이 비활성화되기 전에 호출
        
        print("SceneDelegate: UI Lifecycle - sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        /// Scene이 Background에서 Foreground로 전환될 때 호출
        
        print("SceneDelegate: UI Lifecycle - sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        /// Scene이 Background로 전환될 때 호출
        
        print("SceneDelegate: UI Lifecycle - sceneDidEnterBackground")
        
        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

