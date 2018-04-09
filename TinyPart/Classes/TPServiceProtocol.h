//
//  TPServiceProtocol.h
//  TinyPart
//
//  Created by Yao Li on 2018/4/9.
//  Copyright © 2018年 yaoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPServiceProtocol <NSObject>
@optional
+ (BOOL)singleton;
+ (instancetype)sharedInstance;
@end
