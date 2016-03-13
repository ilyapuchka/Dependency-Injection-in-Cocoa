//
//  APIClientAssembly.swift
//  Swift-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

import UIKit

public class APIClientAssembly: TyphoonAssembly {
    
    public dynamic func apiClient() -> AnyObject {
        return TyphoonDefinition.withClass(APIClientImp.self) { definition in
            
            definition.useInitializer(Selector("initWithBaseURL:session:")) {
                initializer in
                
                initializer.injectParameterWith(TyphoonConfig("baseUrl"))
                initializer.injectParameterWith(self.defaultSession())
            }
            
            definition.injectProperty("logger")
        }
    }
    
    public dynamic func defaultSession() -> AnyObject {
        return TyphoonDefinition.withClass(NSURLSession.self) { definition in
            definition.useInitializer(Selector("sharedSession"))
        }
    }
    
    public dynamic func defaultLogger() -> AnyObject {
        return TyphoonDefinition.withClass(ConsoleLogger.self) { definition in
            definition.scope = .Singleton
        }
    }
    
    public dynamic func config() -> AnyObject {
        return TyphoonDefinition.withConfigName("Configuration.plist")
    }
    
}
