//
//  APIClientAssembly.m
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import "APIClientAssembly.h"
#import "APIClientImp.h"
#import "ConsoleLogger.h"

@implementation APIClientAssembly

- (id<APIClient>)apiClient {
    return [TyphoonDefinition withClass:[APIClientImp class]
                          configuration:^(TyphoonDefinition* definition) {
                              
                              [definition useInitializer:@selector(initWithBaseURL:session:)
                                              parameters:^(TyphoonMethod *initializer) {
                                                  
                                                  [initializer injectParameterWith:TyphoonConfig(@"baseUrl")];
                                                  [initializer injectParameterWith:[self defaultSession]];
                                                  
                                              }];
                              
                              [definition injectProperty:@selector(logger) with:[self defaultLogger]];
                          }];
}

- (id<NetworkSession>)defaultSession {
    return [TyphoonDefinition withClass:[NSURLSession class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(sharedSession)];
                          }];
}

- (id<Logger>)defaultLogger {
    return [TyphoonDefinition withClass:[ConsoleLogger class]
                          configuration:^(TyphoonDefinition *definition) {
                              definition.scope = TyphoonScopeSingleton;
                          }];
}

- (id)config {
    return [TyphoonDefinition withConfigName:@"Configuration.plist"];
}


@end
