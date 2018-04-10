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
    TPURLHostForRouter(@"com.tinypart.test", TestRouter)
    TPURLPathForActionForRouter(@"/action1", action1, TestRouter);
}
@end
