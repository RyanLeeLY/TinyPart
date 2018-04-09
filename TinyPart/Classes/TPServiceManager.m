//
//  TPServiceManger.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPServiceManager.h"

@interface TPServiceManager ()
@property (strong, nonatomic) NSMutableDictionary *servicesDict;
@end

@implementation TPServiceManager
+ (instancetype)sharedInstance {
    static TPServiceManager *TPServiceManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TPServiceManagerInstance = [[TPServiceManager alloc] init];
    });
    return TPServiceManagerInstance;
}

- (void)registerService:(Protocol *)proto impClass:(Class)impClass {
    NSAssert([impClass conformsToProtocol:proto], @"ImpClass must conform to proto!");
    if (![impClass conformsToProtocol:proto]) {
        return;
    }
    [self registerServiceWithName:NSStringFromProtocol(proto) impClass:impClass];
}

- (void)registerServiceWithName:(NSString *)name impClass:(Class)impClass {
    NSParameterAssert(name);
    if (!name) {
        return;
    }
    [self.servicesDict setObject:impClass forKey:name];
}

- (id)serviceWithProtocolName:(NSString *)protoName {
    Class clz = self.servicesDict[protoName];
    if (!clz) {
        return nil;
    }
    BOOL singleton = NO;
    if ([clz respondsToSelector:@selector(singleton)]) {
        singleton = [clz singleton];
    }
    if (!singleton) {
        return [[clz alloc] init];
    } else {
        return [clz sharedInstance];
    }
    return nil;
}

#pragma mark - getter
- (NSMutableDictionary *)servicesDict {
    if (!_servicesDict) {
        _servicesDict = [NSMutableDictionary dictionary];
    }
    return _servicesDict;
}
@end
