//
//  ViewController2.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/11.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "ViewController2.h"
#import "TinyPart.h"
#import "TestModule.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TPNotificationCenter *center1 = [TestModule1 tp_notificationCenter];
    [center1 addObserver:self selector:@selector(testNotification:) name:@"report_notification_from_TestModule2" object:nil];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)testNotification:(id)aNotification {
    NSLog(@"ViewController2 testNotification %@", aNotification);
}

@end
