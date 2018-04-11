//
//  TPModuleManager.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPModuleManager.h"
#import <objc/runtime.h>
#import "TinyPart.h"

@interface TPModuleManager ()
@property (strong, nonatomic) NSMutableDictionary<NSString *, id<TPModuleProtocol>> *modulesDict;

@property (copy, nonatomic) NSArray<id<TPModuleProtocol>> *allModules;
@property (copy, nonatomic) NSData *moduleSortHint;
@end

@implementation TPModuleManager
+ (instancetype)sharedInstance {
    static TPModuleManager *TPModuleManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TPModuleManagerInstance = [[TPModuleManager alloc] init];
    });
    return TPModuleManagerInstance;
}

- (void)registerModule:(Class)clz {
    NSAssert([clz conformsToProtocol:@protocol(TPModuleProtocol)], @"Module class don't conform to 'TPModuleProtocol'");
    if (![clz conformsToProtocol:@protocol(TPModuleProtocol)]) {
        return;
    }
    NSString *className = NSStringFromClass(clz);
    self.modulesDict[className] = [[clz alloc] init];
}

NSInteger moduleSortFunction(id<TPModuleProtocol> obj1, id<TPModuleProtocol> obj2, void *reverse) {
    NSInteger priority1 = 0;
    NSInteger priority2 = 0;
    if ([[obj1 class] respondsToSelector:@selector(modulePriority)]) {
        priority1 = [[obj1 class] modulePriority];
    }
    if ([[obj2 class] respondsToSelector:@selector(modulePriority)]) {
        priority2 = [[obj2 class] modulePriority];
    }
    if (priority2 > priority1) {
        if (*(BOOL *)reverse == NO) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    } else {
        if (*(BOOL *)reverse == NO) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }
}

- (NSArray<id<TPModuleProtocol>> *)allModules {
    if (!_allModules || _allModules.count != self.modulesDict.count) {
        BOOL reverse = NO;
        _allModules = [self.modulesDict.allValues sortedArrayUsingFunction:moduleSortFunction context:&reverse hint:_moduleSortHint];
        _moduleSortHint = [_allModules sortedArrayHint];
    }
    return _allModules;
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if(@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#endif
    
    __block BOOL result = YES;
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            result = [obj application:application didFinishLaunchingWithOptions:launchOptions] && result;
        }
    }];
    
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isAsync = NO;
        if ([[obj class] respondsToSelector:@selector(isAsync)]) {
            isAsync = [[obj class] isAsync];
        }
        if ([obj respondsToSelector:@selector(moduleDidLoad:)]) {
            if (isAsync) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [obj moduleDidLoad:[TinyPart sharedInstance].context];
                });
            } else {
                [obj moduleDidLoad:[TinyPart sharedInstance].context];
            }
        }
    }];
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(applicationWillResignActive:)]) {
            [obj applicationWillResignActive:application];
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [obj applicationDidEnterBackground:application];
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [obj applicationWillEnterForeground:application];
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [obj applicationDidBecomeActive:application];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj applicationWillTerminate:application];
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    __block BOOL result = NO;
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = [obj application:application openURL:url sourceApplication:sourceApplication annotation:annotation] || NO;
    }];
    return result;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    __block BOOL result = NO;
    if(@available(iOS 9.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            result = [obj application:app openURL:url options:options] || NO;
        }];
    }
    return result;
}
#endif

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [obj applicationDidReceiveMemoryWarning:application];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [obj application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [obj application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            [obj application:application didReceiveRemoteNotification:userInfo];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [obj application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
            [obj application:application didReceiveLocalNotification:notification];
        }
    }];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    if(@available(iOS 8.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:didUpdateUserActivity:)]) {
                [obj application:application didUpdateUserActivity:userActivity];
            }
        }];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    if(@available(iOS 8.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:didFailToContinueUserActivityWithType:error:)]) {
                [obj application:application didFailToContinueUserActivityWithType:userActivityType error:error];
            }
        }];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    __block BOOL result = NO;
    if(@available(iOS 8.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:continueUserActivity:restorationHandler:)]) {
                result = [obj application:application continueUserActivity:userActivity restorationHandler:restorationHandler] || NO;
            }
        }];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    __block BOOL result = NO;
    if(@available(iOS 8.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:willContinueUserActivityWithType:)]) {
                result = [obj application:application willContinueUserActivityWithType:userActivityType] || NO;
            }
        }];
    }
    return result;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    if(@available(iOS 8.2, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:handleWatchKitExtensionRequest:reply:)]) {
                [obj application:application handleWatchKitExtensionRequest:userInfo reply:reply];
            }
        }];
    }
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)) {
    if (@available(iOS 10.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(userNotificationCenter:willPresentNotification:withCompletionHandler:)]) {
                [obj userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
            }
        }];
    }
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        [[[TPModuleManager sharedInstance] allModules] enumerateObjectsUsingBlock:^(id<TPModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
                [obj userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
            }
        }];
    }
};
#endif

#pragma mark - getter
- (NSMutableDictionary *)modulesDict {
    if (!_modulesDict) {
        _modulesDict = [NSMutableDictionary dictionary];
    }
    return _modulesDict;
}
@end
