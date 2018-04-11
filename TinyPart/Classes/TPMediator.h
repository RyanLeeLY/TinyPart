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

#define ClangPush _Pragma("clang diagnostic push")
#define ClangPop _Pragma("clang diagnostic pop")
#define ClangDiagnosticUndeclaredSelector _Pragma("clang diagnostic ignored \"-Wundeclared-selector\"")

#define TPURLPathForActionForRouter(path, action, routerClass) \
ClangPush \
ClangDiagnosticUndeclaredSelector \
[[TPMediator sharedInstance] addURLPath:path forAction:NSStringFromSelector(@selector(action)) forRouter:[routerClass class]]; \
ClangPop

@protocol TPMediatorDelegate <NSObject>
@optional
- (BOOL)mediator:(TPMediator *)mediator checkAuthRetryPerformActionHandler:(void(^)(void))retryHandler;
@end

@interface TPMediator : NSObject
@property (weak, nonatomic) id<TPMediatorDelegate> deleagate;

+ (instancetype)sharedInstance;

- (void)setAPPURLSchemes:(NSArray<NSString *> *)schemes;

- (void)addRouter:(Class)routerClass;
- (void)addURLHost:(NSString *)host forRouter:(Class)routerClass;
- (void)addURLPath:(NSString *)path forAction:(NSString *)action forRouter:(Class)routerClass;

- (id)performAction:(NSString *)action router:(NSString *)router params:(NSDictionary *)params;

- (BOOL)openURL:(NSURL *)URL;
- (BOOL)canOpenURL:(NSURL *)URL;
@end
