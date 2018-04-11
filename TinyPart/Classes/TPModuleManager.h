//
//  TPModuleManager.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPModuleProtocol.h"

@class TPContext;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
@interface TPModuleManager : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>
#else
@interface TPModuleManager : NSObject <UIApplicationDelegate>
#endif

@property (copy, nonatomic, readonly) NSArray<id<TPModuleProtocol>> *allModules;

+ (instancetype)sharedInstance;

- (void)registerModule:(Class)clz;
@end
