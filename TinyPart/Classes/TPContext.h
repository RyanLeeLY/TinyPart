//
//  TPContext.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TPEnviromentType) {
    TPEnviromentTypeRelease = 0,
    TPEnviromentTypeDebug,
};

@interface TPContext : NSObject
+ (instancetype)sharedContext;

@property(nonatomic, assign) TPEnviromentType env;

@property(nonatomic, strong) UIApplication *application;

@property(nonatomic, strong) NSDictionary *launchOptions;
@end
