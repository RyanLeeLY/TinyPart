//
//  TinyPart.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPContext.h"
#import "TPModuleManager.h"
#import "TPServiceManager.h"
#import "TPMediator.h"
#import "TPAppDelegate.h"
#import "TPModuleProtocol.h"
#import "TPServiceProtocol.h"
#import "TPNotificationCenter.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#define TinyPartDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define TPMODULE_AUTO_REGISTER(name) \
char * k##name##_mod TinyPartDATA(TinyPartModule) = ""#name"";

#define TPSERVICE_AUTO_REGISTER(servicename,impl) \
char * k##servicename##_service TinyPartDATA(TinyPartService) = "{ \""#servicename"\" : \""#impl"\"}";

#define TPROUTER_AUTO_REGISTER(name) \
char * k##name##_router TinyPartDATA(TinyPartRouter) = ""#name"";

//
//#define TP_MODULE_AUTO_REGISTER \
//+ (void)load { \
//[[TinyPart sharedInstance] registerModule:[self class]];}
//
//#define TPSERVICE_AUTO_REGISTER(protocol_name) \
//+ (void)load { \
//    [[TinyPart sharedInstance] registerService:@protocol(protocol_name) impClass:[self class]];}
//
//#define TPROUTER_AUTO_REGISTER \
//+ (void)load { \
//[[TinyPart sharedInstance] addRouter:[self class]];}

@interface TinyPart : NSObject
@property (strong, nonatomic) TPContext *context;

+ (instancetype)sharedInstance;

- (void)registerModule:(Class)clz;

- (void)registerService:(Protocol *)proto impClass:(Class)impClass;

- (void)addRouter:(Class)routerClass;
@end

