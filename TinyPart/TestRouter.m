//
//  TestRouter.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TestRouter.h"

@implementation TestRouter
TPRouter_AUTH_REQUIRE(@"action1")

TPROUTER_METHOD_EXPORT(action1, {
    NSLog(@"TestRouter action1 params=%@", params);
    return nil;
});
@end
