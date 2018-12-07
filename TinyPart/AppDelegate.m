//
//  AppDelegate.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "AppDelegate.h"
#import "TestModule.h"
#import "TestModuleService.h"
#import "TestRouter.h"

@interface AppDelegate () <TPMediatorDelegate>

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TPMediator sharedInstance].deleagate = self;

    [TPContext sharedContext].launchOptions = launchOptions;
    [TPContext sharedContext].application = application;
    
    TPContext *context = [TPContext sharedContext];
    
    // DefaultFileName:@"TinyPart.bundle/TinyPart.plist";
    context.configPlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.modulePlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.servicePlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.routerPlistFileName = @"TinyPart.bundle/TinyPart.plist";
    
    [TinyPart sharedInstance].context = context;
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

static BOOL login = NO;
- (BOOL)mediator:(TPMediator *)mediator routerAction:(TPMediatorRouterActionModel *)routerAction checkAuthRetryPerformActionHandler:(void (^)(void))retryHandler {
    BOOL isLogin = login;
    [self checkLogin:^{
        if (!isLogin) {
            retryHandler();
        }
    }];
    return login;
}

- (BOOL)checkLogin:(void(^)(void))compeltionHandler {
    if (login) {
        compeltionHandler();
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", @"登录成功");
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                login = YES;
            });
            compeltionHandler();
        });
    }
    return login;
}
@end
