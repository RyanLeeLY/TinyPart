//
//  TestModuleService.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPServiceProtocol.h"

@protocol TestModuleService1 <TPServiceProtocol>
- (void)function1;
@end

@interface TestModuleService1Imp : NSObject <TestModuleService1>
@end

@protocol TestModuleService2 <TPServiceProtocol>
- (void)function2;
@end

@interface TestModuleService2Imp : NSObject <TestModuleService2>
@end
