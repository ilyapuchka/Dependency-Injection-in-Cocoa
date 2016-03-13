//
//  APIClientImp.m
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import "APIClientImp.h"

@interface APIClientImp()

@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, strong) id<NetworkSession> session;

@end

@implementation APIClientImp

- (instancetype)initWithBaseURL:(NSURL *)url session:(id<NetworkSession>)session {
    self = [super init];
    if (self != nil) {
        self.baseURL = url;
        self.session = session;
    }
    return self;
}

- (void)get:(NSString *)path {
    NSURLRequest *request = [self.session request:self.baseURL path:path];
    NSString *message = [NSString stringWithFormat:@"GET %@", request];
    [self.logger log:message];
}

@end
