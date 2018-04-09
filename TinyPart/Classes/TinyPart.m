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
@end
