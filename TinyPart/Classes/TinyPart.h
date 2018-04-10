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
#import "TPMediator.h"
#import "TPAppDelegate.h"
#import "TPModuleProtocol.h"
#import "TPServiceProtocol.h"

#define TP_MODULE_AUTO_REGISTER \
+ (void)load { \
[[TinyPart sharedInstance] registerModule:[self class]];}

#define TPSERVICE_AUTO_REGISTER(protocol_name) \
+ (void)load { \
    [[TinyPart sharedInstance] registerService:@protocol(protocol_name) impClass:[self class]];}

#define TPROUTER_AUTO_REGISTER \
+ (void)load { \
[[TinyPart sharedInstance] addRouter:[self class]];}

@interface TinyPart : NSObject
@property (strong, nonatomic) TPContext *context;

+ (instancetype)sharedInstance;

- (void)registerModule:(Class)clz;

- (void)registerService:(Protocol *)proto impClass:(Class)impClass;

- (void)addRouter:(Class)routerClass;
@end


