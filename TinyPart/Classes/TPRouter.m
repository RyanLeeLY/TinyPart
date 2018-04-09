//
//  TPRouter.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPRouter.h"

NSString * TPRouterNameFromString(NSString *str) {
    NSString *routerName = str;
    if (![[routerName lowercaseString] hasSuffix:@"router"]) {
        routerName = [routerName stringByAppendingString:@"Router"];
    }
    return routerName;
}

SEL TPRouterActionSelectorFromString(NSString *str) {
    NSString *actionName = str;
    if (![actionName hasPrefix:@"TPRouter_"]) {
        actionName = [NSString stringWithFormat:@"TPRouter_%@:", str];
    }
    return NSSelectorFromString(actionName);
}

@implementation TPRouter
+ (NSString *)routerName {
    NSString *routerName = NSStringFromClass(self);
    if (![[routerName lowercaseString] hasSuffix:@"router"]) {
        routerName = [routerName stringByAppendingString:@"Router"];
    }
    return routerName;
}

- (BOOL)authorizationBeforeAction:(NSString *)action {
    return NO;
}
@end
