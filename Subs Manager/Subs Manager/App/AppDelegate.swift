//
//  AppDelegate.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserRemembered),
           UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserLoggedIn) {
            self.showScreen(with: "SubscriptionsScreen", viewControllerName: "SubscriptionsScreen")
        } else {
            self.showScreen(with: "SignInScreen", viewControllerName: "SignInScreen")

        }
        return true
    }

    private func showScreen(with storyboardName: String, viewControllerName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName)

        let navigationController = UINavigationController(rootViewController: viewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

