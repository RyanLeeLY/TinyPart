//
//  TestModule.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TestModule.h"

@implementation TestModule1
TPMODULE_AUTO_REGISTER(TestModule1) // 自动注册模块，动态注册模块

TP_MODULE_ASYNC         // 异步启动模块，优化开屏性能

TP_MODULE_PRIORITY(1)   // 模块启动优先级，优先级高的先启动

TP_MODULE_LEVEL(TPModuleLevelBasic)     // 模块级别：基础模块

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)moduleDidLoad:(TPContext *)context {
    switch (context.env) {
        case TPRunningEnviromentTypeDebug: {
            NSLog(@"%@", @"TestModule1 moduleDidLoad: debug");
            break;
        }
        case TPRunningEnviromentTypeRelease: {
            NSLog(@"%@", @"TestModule1 moduleDidLoad: release");
            break;
        }
    }
}
@end



@implementation TestModule2
TPMODULE_AUTO_REGISTER(TestModule2)

TP_MODULE_ASYNC

TP_MODULE_PRIORITY(2)

TP_MODULE_LEVEL(TPModuleLevelBasic)

- (void)moduleDidLoad:(TPContext *)context {
    switch (context.env) {
        case TPRunningEnviromentTypeDebug: {
            NSLog(@"%@", @"TestModule2 moduleDidLoad: debug");
            break;
        }
        case TPRunningEnviromentTypeRelease: {
            NSLog(@"%@", @"TestModule2 moduleDidLoad: release");
            break;
        }
    }
}
@end



@implementation TestModule3
TP_MODULE_PRIORITY(100)

TP_MODULE_LEVEL(TPModuleLevelTopout)

- (void)moduleDidLoad:(TPContext *)context {
    switch (context.env) {
        case TPRunningEnviromentTypeDebug: {
            NSLog(@"%@", @"TestModule3 moduleDidLoad: debug");
            break;
        }
        case TPRunningEnviromentTypeRelease: {
            NSLog(@"%@", @"TestModule3 moduleDidLoad: release");
            break;
        }
    }
}
@end
