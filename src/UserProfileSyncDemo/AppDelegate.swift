//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var loginViewController:LoginViewController?
    fileprivate var userProfileViewController:ProfileViewController?
    fileprivate var userProfileNavViewController:UINavigationController?
    
    fileprivate var cbMgr = DatabaseManager.shared
    fileprivate var isObservingForLoginEvents:Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.loadLoginViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK : Notification Observers
extension AppDelegate {
    func loadLoginViewController() {
        if let loginVC = loginViewController {
            window?.rootViewController = loginVC
        }
        else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            window?.rootViewController = loginViewController
            
        }
        self.registerNotificationObservers()
    }
    
    func loadProfileViewController() {
        if let profileNVC = userProfileNavViewController {
            window?.rootViewController = profileNVC
        }
        else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            userProfileNavViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileNVC") as? UINavigationController
            window?.rootViewController = userProfileNavViewController
        }
        
    }
    
    func login() {
        self.cbMgr.startPushAndPullReplicationForCurrentUser()
        loadProfileViewController()
    }
    
    func logout() {
        self.deregisterNotificationObservers()
        self.cbMgr.stopAllReplicationForCurrentUser()
        let _ = DatabaseManager.shared.closeDatabaseForCurrentUser()
        loadLoginViewController()
    }
    
    func isUserLoggedIn() -> Bool{
        return self.window?.rootViewController == userProfileViewController
    }
}

// MARK: Observers
extension AppDelegate {
    
    func registerNotificationObservers() {
        if isObservingForLoginEvents == false {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AppNotifications.loginInSuccess.name.rawValue), object: nil, queue: nil) { [weak self] (notification) in
                guard let `self` = self else { return }
                self.login()
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AppNotifications.loginInFailure.name.rawValue), object: nil, queue: nil) {[unowned self] (notification) in
                if let userInfo = (notification as NSNotification).userInfo as? Dictionary<String,String> {
                    if let _ = userInfo[AppNotifications.loginInSuccess.userInfoKeys.user.rawValue]{
                        self.logout()
                    }
                }
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: AppNotifications.logout.name.rawValue), object: nil, queue: nil) { [unowned self] (notification) in
                self.logout()
            }
            isObservingForLoginEvents = true
        }
    }
    
    func deregisterNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppNotifications.loginInSuccess.name.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppNotifications.loginInFailure.name.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppNotifications.logout.name.rawValue), object: nil)
        isObservingForLoginEvents = false
    }
}
