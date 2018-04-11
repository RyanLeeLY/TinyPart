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
#import "TestModule.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<TestModuleService1> service1 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService1"];
    [service1 function1];
    
    id<TestModuleService2> service2 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService2"];
    [service2 function2];
    
    id<TestModuleService3> service3 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService3"];
    [service3 function3];
    
    [[TPMediator sharedInstance] performAction:@"action2" router:@"Test" params:@{}];
    NSURL *url = [NSURL URLWithString:@"tinypart://com.tinypart.test/action1?id=1&name=tinypart"];
    [[TPMediator sharedInstance] openURL:url];
    
    TPNotificationCenter *center3 = [TestModule3 tp_notificationCenter];
    [center3 addObserver:self selector:@selector(testNotification:) name:@"broadcast_notification_from_TestModule2" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TPNotificationCenter *center2 = [TestModule2 tp_notificationCenter];
    [center2 reportNotification:^(TPNotificationMaker *make) {
        make.name(@"report_notification_from_TestModule2");
    } targetModule:@"TestModule1"];
    
    [center2 broadcastNotification:^(TPNotificationMaker *make) {
        make.name(@"broadcast_notification_from_TestModule2").userInfo(@{@"key":@"value"}).object(self);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testNotification:(id)aNotification {
    NSLog(@"ViewController testNotification %@", aNotification);
}

@end
