//
//  Logger.h
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Logger <NSObject>

- (void)log:(NSString *)message;

@end
