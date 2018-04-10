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
    id<TestModuleService1> service1 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService1"];
    [service1 function1];
    
    id<TestModuleService2> service2 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService2"];
    [service2 function2];
    
    [[TPMediator sharedInstance] performAction:@"action1" router:@"Test" params:@{}];
    [[TPMediator sharedInstance] openURL:[NSURL URLWithString:@"tinypart://com.tinypart.test/action1?id=1&name=tinypart"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
