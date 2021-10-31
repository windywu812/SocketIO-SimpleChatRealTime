//
//  SceneDelegate.swift
//  SocketIO-RealTime
//
//  Created by Windy on 29/10/21.
//

import UIKit
import SocketIO

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()

        let vc = ViewController(chatService: ChatService())
        
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }

}
