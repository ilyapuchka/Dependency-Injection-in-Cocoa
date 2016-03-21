//
//  AppDelegate.m
//  ObjectiveC-DI
//
//  Created by Ilya Puchka on 28.02.16.
//  Copyright © 2016 Ilay Puchka. All rights reserved.
//

#import "AppDelegate.h"
#import "APIClientAssembly.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    APIClientAssembly *assembly = [[APIClientAssembly new] activate];
    id<APIClient> apiClient = [assembly apiClient];
    
    [apiClient get:@"path"];
    
    return YES;
}

@end

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet id<APIClient> apiClient;

@end

@implementation ViewController



@end
