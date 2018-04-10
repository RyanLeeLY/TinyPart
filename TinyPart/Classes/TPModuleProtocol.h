//
//  TPModuleProtocol.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#define TP_MODULE_ASYNC \
+ (BOOL)isAsync { \
    return YES;}

#define TP_MODULE_PRIORITY(priority) \
+ (NSInteger)modulePriority { \
    return priority;}

@class TPContext;

@protocol TPModuleProtocol <NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate>
@optional
+ (BOOL)isAsync;
+ (NSInteger)modulePriority;

- (void)moduleDidLoad:(TPContext *)context;
@end
