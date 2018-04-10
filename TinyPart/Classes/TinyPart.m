//
//  TinyPart.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TinyPart.h"

@interface TinyPart ()
@end

@implementation TinyPart
+ (instancetype)sharedInstance {
    static TinyPart *TPInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TPInstance = [[TinyPart alloc] init];
    });
    return TPInstance;
}

- (void)registerModule:(Class)clz {
    [[TPModuleManager sharedInstance] registerModule:clz];
}

- (void)registerService:(Protocol *)proto impClass:(Class)impClass {
    [[TPServiceManager sharedInstance] registerService:proto impClass:impClass];
}

- (void)addRouter:(Class)routerClass {
    [[TPMediator sharedInstance] addRouter:routerClass];
}

- (void)setContext:(TPContext *)context {
    NSBundle *bundle = context.plistBundle?:[NSBundle mainBundle];
    
    NSString *modulePlistFilePath = [bundle pathForResource:context.modulePlistFileName ofType:nil];
    NSString *servicePlistFilePath = [bundle pathForResource:context.servicePlistFileName ofType:nil];
    NSString *routerPlistFilePath = [bundle pathForResource:context.routerPlistFileName ofType:nil];
    
    NSDictionary *moduleDict = [NSDictionary dictionaryWithContentsOfFile:modulePlistFilePath];
    NSArray *moduleArray = moduleDict[@"ModuleClasses"];
    [moduleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self registerModule:NSClassFromString(obj)];
    }];
    
    NSDictionary *serviceDict = [NSDictionary dictionaryWithContentsOfFile:servicePlistFilePath];
    NSDictionary *serviceTable = serviceDict[@"ServicesTable"];
    [serviceTable enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self registerService:NSProtocolFromString(key) impClass:NSClassFromString(obj)];
    }];
    
    NSDictionary *routerDict = [NSDictionary dictionaryWithContentsOfFile:routerPlistFilePath];
    NSArray *routerArray = routerDict[@"RouterClasses"];
    [routerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addRouter:NSClassFromString(obj)];
    }];
    
    _context = context;
}
@end
