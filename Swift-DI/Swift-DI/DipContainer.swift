//
//  DipContainer.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 12.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import Dip

func configureContainer() -> DependencyContainer {
    let container = DependencyContainer { container in
        
        container.register {
            try APIClientImp(
                baseURL: container.resolve(tag: "baseUrl"),
                session: container.resolve()
                ) as APIClient }
            .resolveDependencies { (container, var client) in
                client.logger = try container.resolve() as Logger
        }
        
        container.register { NSURLSession.sharedSession() as NetworkSession }
        
        container.register(.Singleton) { ConsoleLogger() as Logger }
        
        container.register(.Singleton) { Config(fileName: "Configuration.plist")! }
        
        container.register(tag: "baseUrl") {
            try NSURL(string: (container.resolve() as Config).valueForKey("baseUrl")!)!
        }
    }
    return container
}

class Config {
    var plist: [String: AnyObject]!
    
    init?(fileName: String) {
        guard let
            path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil),
            data = NSData(contentsOfFile: path),
            plist = (try? NSPropertyListSerialization.propertyListWithData(data, options: [], format: nil)) as? [String: AnyObject] else {
                return nil
        }
        self.plist = plist
    }

    func valueForKey<T>(key: String) -> T? {
        return plist[key] as? T
    }
}
