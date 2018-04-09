//
//  TPMediator.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPMediator.h"
#import "TPServiceManager.h"
#import <objc/runtime.h>

@implementation TPMediator
+ (instancetype)sharedInstance {
    static TPMediator *TPMediatorInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TPMediatorInstance = [[TPMediator alloc] init];
    });
    return TPMediatorInstance;
}

- (void)addRouter:(Class)routerClass {
    NSAssert([routerClass isSubclassOfClass:[TPRouter class]], @"routerClass must be the sub-class of TPRouter");
    if (![routerClass isSubclassOfClass:[TPRouter class]]) {
        return;
    }
    NSString *routerName = [routerClass routerName];
    [[TPServiceManager sharedInstance] registerServiceWithName:routerName impClass:routerClass];
}

- (id)performAction:(NSString *)action router:(NSString *)router params:(NSDictionary *)params {
    NSString *routerName = TPRouterNameFromString(router);
    TPRouter *routerService = [[TPServiceManager sharedInstance] serviceWithProtocolName:routerName];
    BOOL needAuth = [routerService authorizationBeforeAction:action];
    if (needAuth) {
        
    }
    
    SEL selector = TPRouterActionSelectorFromString(action);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([routerService respondsToSelector:selector]) {
        [routerService performSelector:selector withObject:params];
    }
#pragma clang diagnostic pop

    return nil;
}
@end
