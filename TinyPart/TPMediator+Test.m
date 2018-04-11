//
//  TPMediator+Test.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/10.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPMediator+Test.h"
#import "TinyPart.h"
#import "TestRouter.h"

@implementation TPMediator (Test)
+ (void)load {
    // 声明TestRouter对应的Host
    TPURLHostForRouter(@"com.tinypart.test", TestRouter) // tinypart://com.tinypart.test
    
    // 声明TestRouter中action1对应的Path
    TPURLPathForActionForRouter(@"/action1", action1, TestRouter);  // tinypart://com.tinypart.test/action1
}
@end
