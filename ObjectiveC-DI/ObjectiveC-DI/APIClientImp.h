//
//  APIClientImp.h
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "Logger.h"
#import "NetworkSession.h"

@interface APIClientImp : NSObject <APIClient>

- (instancetype)initWithBaseURL:(NSURL *)url session:(id<NetworkSession>)session;

@property (nonatomic, strong) id<Logger> logger;

@end
