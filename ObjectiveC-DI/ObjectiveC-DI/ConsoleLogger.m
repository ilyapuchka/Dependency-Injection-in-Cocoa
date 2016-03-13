//
//  ConsoleLogger.m
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import "ConsoleLogger.h"

@implementation ConsoleLogger

- (void)log:(NSString *)message {
    NSLog(@"[%@ <%p>]: %@", [self class], self, message);
}

@end
