//
//  TPModuleProtocol.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@class TPContext;

@protocol TPModuleProtocol <NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate>
@optional
- (void)moduleDidLoad:(TPContext *)context;
@end
