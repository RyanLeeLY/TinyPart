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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[TPModuleManager sharedInstance] applicationDidReceiveMemoryWarning:application];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[TPModuleManager sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[TPModuleManager sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[TPModuleManager sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[TPModuleManager sharedInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[TPModuleManager sharedInstance] application:application didReceiveLocalNotification:notification];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    [[TPModuleManager sharedInstance] application:application didUpdateUserActivity:userActivity];
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    [[TPModuleManager sharedInstance] application:application didFailToContinueUserActivityWithType:userActivityType error:error];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    return [[TPModuleManager sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    return [[TPModuleManager sharedInstance] application:application willContinueUserActivityWithType:userActivityType];
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if (@available(iOS 8.2, *)) {
        [[TPModuleManager sharedInstance] application:application handleWatchKitExtensionRequest:userInfo reply:reply];
    }
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)) {
    [[TPModuleManager sharedInstance] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    [[TPModuleManager sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
};
#endif

@end
