//
//  TestRouter.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TestRouter.h"
#import "TinyPart.h"

@implementation TestRouter
TPROUTER_AUTO_REGISTER  // 自动注册路由

// APP身份验证，需要实现TPMediatorDelegate中的身份验证回调
TPRouter_AUTH_REQUIRE(@"action1", @"action2")

TPROUTER_METHOD_EXPORT(action1, {
    NSLog(@"TestRouter action1 params=%@", params);
    return nil;
});

TPROUTER_METHOD_EXPORT(action2, {
    NSLog(@"TestRouter action2 params=%@", params);
    return nil;
});
@end
