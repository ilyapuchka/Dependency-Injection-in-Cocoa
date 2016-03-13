//
//  AppDelegate.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Typhoon
        let assembly = APIClientAssembly().activate()
        let apiClient = assembly.apiClient() as! APIClient
        
        apiClient.get("path")
        
        //Dip
        let container = configureContainer()
        let dipClient = try! container.resolve() as APIClient
        
        dipClient.get("path")
        
        return true
    }

}

