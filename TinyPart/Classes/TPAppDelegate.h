//
//  TPAppDelegate.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
@interface TPAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
#else
@interface TPAppDelegate : UIResponder <UIApplicationDelegate>
#endif

@end
