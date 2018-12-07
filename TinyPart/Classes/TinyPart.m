//
//  TinyPart.m
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import "TinyPart.h"
#include <dlfcn.h>
#include <mach-o/getsect.h>
#include <mach-o/dyld.h>

static NSString * const TP_PLIST_APPURLSCHEME_KEY = @"APPURLSchemes";
static NSString * const TP_PLIST_MODULE_KEY = @"ModuleClasses";
static NSString * const TP_PLIST_SERVICE_KEY = @"ServicesTable";
static NSString * const TP_PLIST_ROUTER_KEY = @"RouterClasses";

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
    
    NSString *configPlistFilePath = [bundle pathForResource:context.configPlistFileName ofType:nil];
    NSString *modulePlistFilePath = [bundle pathForResource:context.modulePlistFileName ofType:nil];
    NSString *servicePlistFilePath = [bundle pathForResource:context.servicePlistFileName ofType:nil];
    NSString *routerPlistFilePath = [bundle pathForResource:context.routerPlistFileName ofType:nil];
    
    if (configPlistFilePath) {
        NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:configPlistFilePath];
        NSArray *schemes = configDict[TP_PLIST_APPURLSCHEME_KEY];
        [[TPMediator sharedInstance] setAPPURLSchemes:schemes];
    }
    
    if (modulePlistFilePath) {
        NSDictionary *moduleDict = [NSDictionary dictionaryWithContentsOfFile:modulePlistFilePath];
        NSArray *moduleArray = moduleDict[TP_PLIST_MODULE_KEY];
        [moduleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self registerModule:NSClassFromString(obj)];
        }];
    }
    
    if (servicePlistFilePath) {
        NSDictionary *serviceDict = [NSDictionary dictionaryWithContentsOfFile:servicePlistFilePath];
        NSDictionary *serviceTable = serviceDict[TP_PLIST_SERVICE_KEY];
        [serviceTable enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self registerService:NSProtocolFromString(key) impClass:NSClassFromString(obj)];
        }];
    }
    
    if (routerPlistFilePath) {
        NSDictionary *routerDict = [NSDictionary dictionaryWithContentsOfFile:routerPlistFilePath];
        NSArray *routerArray = routerDict[TP_PLIST_ROUTER_KEY];
        [routerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addRouter:NSClassFromString(obj)];
        }];
    }
    
    _context = context;
}
@end

NSArray<NSString *>* TPReadConfiguration(char *sectionName,const struct mach_header *mhp);
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    // register module
    NSArray *mods = TPReadConfiguration("TinyPartModule", mhp);
    for (NSString *modName in mods) {
        if (modName) {
            Class cls = NSClassFromString(modName);
            if (cls) {
                [[TinyPart sharedInstance] registerModule:cls];
            }
        }
    }
    
    // register services
    NSArray<NSString *> *services = TPReadConfiguration("TinyPartService",mhp);
    for (NSString *map in services) {
        NSData *jsonData =  [map dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count) {
                
                NSString *protocol = [json allKeys][0];
                NSString *clsName  = [json allValues][0];
                
                if (protocol && clsName) {
                    [[TinyPart sharedInstance] registerService:NSProtocolFromString(protocol) impClass:NSClassFromString(clsName)];
                }
                
            }
        }
    }
    
    // register router
    NSArray *routers = TPReadConfiguration("TinyPartRouter", mhp);
    for (NSString *routerName in routers) {
        if (routerName) {
            Class cls = NSClassFromString(routerName);
            if (cls) {
                [[TinyPart sharedInstance] addRouter:cls];
            }
        }
    }
    
}
__attribute__((constructor))
void initProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

NSArray<NSString *>* TPReadConfiguration(char *sectionName,const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        if(str) [configs addObject:str];
    }
    
    return configs;
    
    
}
