//
//  TinyPart.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "TPContext.h"
#import "TPModuleManager.h"
#import "TPServiceManager.h"
#import "TPAppDelegate.h"

@interface TinyPart : NSObject
@property (strong, nonatomic) TPContext *context;

+ (instancetype)sharedInstance;
@end


