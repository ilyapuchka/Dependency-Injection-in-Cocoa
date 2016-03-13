//
//  NetworkSession.h
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 12.03.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkSession <NSObject>

- (NSURLRequest *)request:(NSURL *)baseURL path:(NSString *)path;

@end
