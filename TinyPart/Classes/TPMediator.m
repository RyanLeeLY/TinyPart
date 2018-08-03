//
//  TPMediator.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TPMediator.h"
#import "TPServiceManager.h"
#import "TPRouter.h"
#import "TinyPart.h"

NSString * const TPMediatorIgnoreAuthCheckParameterName = @"TPMediatorIgnoreAuthCheckParameterName";

@interface TPMediator ()
@property (strong, nonatomic) NSMutableDictionary *nativeRouterHostDict;        // {host: routerName}
@property (strong, nonatomic) NSMutableDictionary *nativeRouterActionPathDict;  // {routerName:{path:actionName}}
@property (strong, nonatomic) NSArray *appURLSchemes;
@end

@implementation TPMediator
+ (instancetype)sharedInstance {
    static TPMediator *TPMediatorInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TPMediatorInstance = [[TPMediator alloc] init];
    });
    return TPMediatorInstance;
}

- (void)setAPPURLSchemes:(NSArray<NSString *> *)schemes {
    if (_appURLSchemes == schemes) {
        return;
    }
    _appURLSchemes = schemes;
}

- (void)addRouter:(Class)routerClass {
    NSAssert([routerClass isSubclassOfClass:[TPRouter class]], @"routerClass:%@ must be the sub-class of TPRouter", NSStringFromClass(routerClass));
    if (![routerClass isSubclassOfClass:[TPRouter class]]) {
        return;
    }
    NSString *routerName = [routerClass routerName];
    [[TPServiceManager sharedInstance] registerServiceWithName:routerName impClass:routerClass];
}

- (void)addURLHost:(NSString *)host forRouter:(Class)routerClass {
    NSParameterAssert(host);
    NSParameterAssert(routerClass);
    NSAssert([routerClass isSubclassOfClass:[TPRouter class]], @"routerClass:%@ must be the sub-class of TPRouter", NSStringFromClass(routerClass));
    if (!host || !routerClass) {
        return;
    }
    NSString *routerName = [routerClass routerName];
    if (!routerName) {
        return;
    }
    self.nativeRouterHostDict[host] = routerName;
}

- (void)addURLPath:(NSString *)path forAction:(NSString *)action forRouter:(Class)routerClass {
    NSParameterAssert(path);
    NSParameterAssert(action);
    NSParameterAssert(routerClass);
    NSAssert([routerClass isSubclassOfClass:[TPRouter class]], @"routerClass:%@ must be the sub-class of TPRouter", NSStringFromClass(routerClass));
    if (!path || !action || !routerClass) {
        return;
    }
    NSString *routerName = [routerClass routerName];
    if (!routerName) {
        return;
    }
    if (self.nativeRouterActionPathDict[routerName]) {
        self.nativeRouterActionPathDict[routerName][path] = action;
    } else {
        self.nativeRouterActionPathDict[routerName] = [NSMutableDictionary dictionaryWithObject:action forKey:path];
    }
}

- (id)performAction:(NSString *)action router:(NSString *)router params:(NSDictionary *)params {
    NSString *routerName = TPRouterNameFromString(router);
    TPRouter *routerService = [[TPServiceManager sharedInstance] serviceWithName:routerName];
    BOOL needAuth = [routerService authorizationBeforeAction:action];
    BOOL ignore = [params[TPMediatorIgnoreAuthCheckParameterName] boolValue];
    if (needAuth && !ignore) {
        NSLog(@"%@", @"Authorization required");
        __weak typeof (self) weakSelf = self;
        if ([self.deleagate respondsToSelector:@selector(mediator:routerAction:checkAuthRetryPerformActionHandler:)]) {
            TPMediatorRouterActionModel *model = [[TPMediatorRouterActionModel alloc] init];
            model.action = action;
            model.router = router;
            model.params = params;
            if (![self.deleagate mediator:self routerAction:model checkAuthRetryPerformActionHandler:^{
                [weakSelf performAction:action router:router params:params];
            }]) {
                return nil;
            }
            
        }
    }
    
    SEL selector = TPRouterActionSelectorFromString(action);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([routerService respondsToSelector:selector]) {
        return [routerService performSelector:selector withObject:params];
    }
#pragma clang diagnostic pop

    return nil;
}

- (BOOL)openURL:(NSURL *)URL {
    if (![self canOpenURL:URL]) {
        return NO;
    }
    NSString *host = URL.host;
    NSString *path = URL.path.length>0?URL.path:@"/";
    
//    NSString *tabBarItemString = URL.fragment;
    // TODO: tabbar处理
    
    NSString *router = self.nativeRouterHostDict[host];
    NSString *action = self.nativeRouterActionPathDict[router][path];
    
    [self performAction:action router:router params:TPDictionaryFromURLQueryString(URL.query)];
    
    return YES;
}

- (BOOL)canOpenURL:(NSURL *)URL {
    if (![self.appURLSchemes containsObject:URL.scheme]) {
        return NO;
    }
    
    NSString *host = URL.host;
    NSString *path = URL.path.length>0?URL.path:@"/";
    
    NSString *router = self.nativeRouterHostDict[host];
    NSString *action = self.nativeRouterActionPathDict[router][path];
    
    if (!router || !action) {
        return NO;
    }
    
    return YES;
}

- (NSMutableDictionary *)nativeRouterHostDict {
    if (!_nativeRouterHostDict) {
        _nativeRouterHostDict = [NSMutableDictionary dictionary];
    }
    return _nativeRouterHostDict;
}

- (NSMutableDictionary *)nativeRouterActionPathDict {
    if (!_nativeRouterActionPathDict) {
        _nativeRouterActionPathDict = [NSMutableDictionary dictionary];
    }
    return _nativeRouterActionPathDict;
}

static inline NSDictionary * TPDictionaryFromURLQueryString(NSString *query) {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[[elts lastObject] stringByRemovingPercentEncoding] forKey:[[elts firstObject] stringByRemovingPercentEncoding]];
    }
    return [params copy];
}
@end

@implementation TPMediatorRouterActionModel
@end
