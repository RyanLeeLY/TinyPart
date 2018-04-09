//
//  TPModuleManager.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "TPModuleProtocol.h"

@class TPContext;

@interface TPModuleManager : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)sharedInstance;

- (void)registerModule:(Class)clz;

- (NSArray<id<TPModuleProtocol>> *)allModules;
@end
