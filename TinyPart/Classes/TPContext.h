//
//  TPContext.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TPRunningEnviromentType) {
    TPRunningEnviromentTypeRelease = 0,
    TPRunningEnviromentTypeDebug,
};

@interface TPContext : NSObject
+ (instancetype)sharedContext;

@property(assign, nonatomic) TPRunningEnviromentType env;

@property(strong, nonatomic) UIApplication *application;

@property(strong, nonatomic) NSDictionary *launchOptions;

@property(strong, nonatomic) NSBundle *plistBundle;
@property(copy, nonatomic) NSString *modulePlistFileName;
@property(copy, nonatomic) NSString *servicePlistFileName;
@property(copy, nonatomic) NSString *routerPlistFileName;
@end
