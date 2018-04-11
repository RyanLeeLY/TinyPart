//
//  TPModuleProtocol.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPContext;
@class TPNotificationCenter;

#define TP_MODULE_ASYNC \
+ (BOOL)isAsync { \
    return YES;}

#define TP_MODULE_PRIORITY(priority) \
+ (NSInteger)modulePriority { \
    return priority;}

#define TP_MODULE_LEVEL(ModuleLevel) \
+ (TPModuleLevel)moduleLevel {\
    return ModuleLevel;}


typedef NS_ENUM(NSUInteger, TPModuleLevel) {
    TPModuleLevelBasic = 0,
    TPModuleLevelMiddle,
    TPModuleLevelTopout,
};

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
@protocol TPModuleProtocol <NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate>
#else
@protocol TPModuleProtocol <NSObject, UIApplicationDelegate>
#endif

@optional
+ (BOOL)isAsync;
+ (NSInteger)modulePriority;
+ (TPModuleLevel)moduleLevel;

- (void)moduleDidLoad:(TPContext *)context;

+ (TPNotificationCenter *)tp_notificationCenter;
@end
