//
//  NSURLSession+NetworkSession.m
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 12.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import "NSURLSession+NetworkSession.h"

@implementation NSURLSession (NetworkSession)

- (NSURLRequest *)request:(NSURL *)baseURL path:(NSString *)path {
    return [NSURLRequest requestWithURL:[baseURL URLByAppendingPathComponent:path]];
}

@end
