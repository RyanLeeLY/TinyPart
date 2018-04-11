//
//  TPNotificationCenter.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/11.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPNotificationMaker;
@protocol TPModuleProtocol;

@interface TPNotificationCenter : NSObject
+ (instancetype)centerWithModule:(Class)module;

- (void)broadcastNotification:(void(^)(TPNotificationMaker *make))makerHandler;
- (void)reportNotification:(void(^)(TPNotificationMaker *make))makerHandler targetModule:(NSString *)moduleName;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
@end

@interface TPNotificationMaker : NSObject
- (TPNotificationMaker *(^)(NSString *name))name;
- (TPNotificationMaker *(^)(id object))object;
- (TPNotificationMaker *(^)(id userInfo))userInfo;
@end
