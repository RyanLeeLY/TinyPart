//
//  TPRouter.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPServiceProtocol.h"

#define TPRouter_AUTH_REQUIRE(...) \
- (BOOL)authorizationBeforeAction:(NSString *)action { \
    static dispatch_once_t onceToken; \
    static NSSet *authRequireSet; \
    dispatch_once(&onceToken, ^{ \
        authRequireSet = [NSSet setWithObjects:__VA_ARGS__, nil]; \
    }); \
    if ([authRequireSet containsObject:action] \
        || [authRequireSet containsObject:[NSString stringWithFormat:@"%@_%@",[self class].routerName, action]] \
    ) { \
        return YES; \
    } \
    return NO; \
}

#define TPROUTER_METHOD_EXPORT(action, method, ...) \
- (id)TPRouter_##action:(NSDictionary *)params method, ##__VA_ARGS__

NSString * TPRouterNameFromString(NSString *str);
SEL TPRouterActionSelectorFromString(NSString *str);

@interface TPRouter : NSObject <TPServiceProtocol>
+ (NSString *)routerName;

- (BOOL)authorizationBeforeAction:(NSString *)action;
@end
