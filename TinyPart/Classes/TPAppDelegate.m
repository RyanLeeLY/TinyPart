//
//  TPAppDelegate.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPAppDelegate.h"
#import "TinyPart.h"
#import "TPModuleManager.h"

@implementation TPAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[TPModuleManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationWillTerminate:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   return [[TPModuleManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80400
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (@available(iOS 9.0, *)) {
        return [[TPModuleManager sharedInstance] application:app openURL:url options:options];
    }
    return NO;
}
#endif

@end
