//
//  TPMediator.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPMediator;

#define TPURLHostForRouter(host, routerClass) \
[[TPMediator sharedInstance] addURLHost:host forRouter:[routerClass class]];

#define TPURLPathForActionForRouter(path, action, routerClass) \
[[TPMediator sharedInstance] addURLPath:path forAction:action forRouter:[routerClass class]];

static NSString * const TPAppURLScheme = @"tinypart";

@protocol TPMediatorDelegate <NSObject>
@optional
- (BOOL)mediator:(TPMediator *)mediator checkAuthRetryPerformActionHandler:(void(^)(void))retryHandler;
@end

@interface TPMediator : NSObject
@property (weak, nonatomic) id<TPMediatorDelegate> deleagate;

+ (instancetype)sharedInstance;

- (void)addRouter:(Class)routerClass;
- (void)addURLHost:(NSString *)host forRouter:(Class)routerClass;
- (void)addURLPath:(NSString *)path forAction:(NSString *)action forRouter:(Class)routerClass;

- (id)performAction:(NSString *)action router:(NSString *)router params:(NSDictionary *)params;

- (BOOL)openURL:(NSURL *)URL;
- (BOOL)canOpenURL:(NSURL *)URL;
@end
