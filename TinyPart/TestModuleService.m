//
//  TestModuleService.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TestModuleService.h"

@implementation TestModuleService1Imp
- (void)function1 {
    NSLog(@"%@", @"TestModuleService1 function1");
}
@end

@implementation TestModuleService2Imp
+ (BOOL)singleton {
    return YES;
}

+ (instancetype)sharedInstance {
    static TestModuleService2Imp *TestModuleService2ImpInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TestModuleService2ImpInstance = [[TestModuleService2Imp alloc] init];
    });
    return TestModuleService2ImpInstance;
}

- (void)function2 {
    NSLog(@"%@", @"TestModuleService2 function2");
}
@end
