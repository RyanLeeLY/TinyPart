//
//  TestModule.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TestModule.h"

@implementation TestModule1
TP_MODULE_AUTO_REGISTER

TP_MODULE_ASYNC
TP_MODULE_PRIORITY(1)

TP_MODULE_LEVEL(TPModuleLevelBasic)

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
TP_MODULE_AUTO_REGISTER

TP_MODULE_ASYNC
TP_MODULE_PRIORITY(2)

TP_MODULE_LEVEL(TPModuleLevelMiddle)

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
