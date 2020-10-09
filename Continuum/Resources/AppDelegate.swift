//
//  AppDelegate.swift
//  Continuum
//
//  Created by DevMountain on 2/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    func isSignedIn() {
    
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { checkAccountStatus { (success) in
        let fetchedUserStatment = success ? "Successfully retrieved a logged in user" : "Failed to retrieve a logged in user"
        print(fetchedUserStatment) }
        return true
        
    }
    
    func checkAccountStatus(completion: @escaping (Bool) -> Void) { CKContainer.default().accountStatus { (status, error) in if let error = error { print("Error checking accountStatus \(error) \(error.localizedDescription)")
        
        completion(false); return } else { DispatchQueue.main.async { let tabBarController = self.window?.rootViewController
            
            let errrorText = "Sign into iCloud in Settings"
            switch status {
            case .available: completion(true);
            case .noAccount: tabBarController?.presentSimpleAlertWith(title: errrorText, message: "No account found")
                completion(false)
            case .couldNotDetermine: tabBarController?.presentSimpleAlertWith(title: errrorText, message: "There was an unknown error fetching your iCloud Account")
                completion(false)
            case .restricted: tabBarController?.presentSimpleAlertWith(title: errrorText, message: "Your iCloud account is restricted")
                completion(false)
                    }
                }
            }
        }
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

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) { let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true)
        
    }
    
}
