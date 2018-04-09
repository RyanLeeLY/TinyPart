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

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TPContext sharedContext].launchOptions = launchOptions;
    [TPContext sharedContext].application = application;
    [TinyPart sharedInstance].context = [TPContext sharedContext];
    [[TPModuleManager sharedInstance] registerModule:[TestModule class]];
    [[TPServiceManager sharedInstance] registerService:@protocol(TestModuleService1) impClass:[TestModuleService1Imp class]];
    [[TPServiceManager sharedInstance] registerService:@protocol(TestModuleService2) impClass:[TestModuleService2Imp class]];

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


@end
