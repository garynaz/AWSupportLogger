//
//  AWSupportLoggerApp.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 7/28/21.
//

import SwiftUI
import Firebase

@main
struct AWSupportLoggerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
    
    
    
    class AppDelegate:NSObject,UIApplicationDelegate{
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
    }
    
    
}
