//
//  APIClientAssembly.h
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import <Typhoon/Typhoon.h>
#import "APIClient.h"
#import "Logger.h"
#import "NetworkSession.h"

@interface APIClientAssembly: TyphoonAssembly

- (id<APIClient>)apiClient;

- (id<NetworkSession>)defaultSession;

- (id<Logger>)defaultLogger;

@end
