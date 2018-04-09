//
//  ViewController.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "ViewController.h"
#import "TinyPart.h"
#import "TestModuleService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id<TestModuleService1> service1 = [[TPServiceManager sharedInstance] serviceWithProtocolName:@"TestModuleService1"];
    [service1 function1];
    
    id<TestModuleService2> service2 = [[TPServiceManager sharedInstance] serviceWithProtocolName:@"TestModuleService2"];
    [service2 function2];
    
    [[TPMediator sharedInstance] performAction:@"action1" router:@"Test" params:@{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
