//
//  TPServiceManger.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/8.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPServiceProtocol.h"

@interface TPServiceManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerService:(Protocol *)proto impClass:(Class)impClass;
- (void)registerServiceWithName:(NSString *)name impClass:(Class)impClass;

- (id)serviceWithName:(NSString *)name;
@end
