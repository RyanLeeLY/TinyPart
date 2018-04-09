//
//  TPMediator.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPRouter.h"

@interface TPMediator : NSObject
+ (instancetype)sharedInstance;

- (void)addRouter:(Class)routerClass;

- (id)performAction:(NSString *)action router:(NSString *)router params:(NSDictionary *)params;

@end
