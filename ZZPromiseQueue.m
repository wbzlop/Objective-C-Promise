//
//  ZZPromiseQueue.m
//  ESDK
//
//  Created by wbz on 2019/1/16.
//  Copyright © 2019年 zhizhen. All rights reserved.
//

#import "ZZPromiseQueue.h"

@interface ZZPromiseQueue()

@property (nonatomic,strong)NSMutableArray<ZZPromise *> *promiseArray;

@end

@implementation ZZPromiseQueue

+(instancetype)defaultQueue
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray<ZZPromise *> *)promiseArray
{
    if(_promiseArray == nil)
    {
        _promiseArray = [NSMutableArray array];
    }
    return _promiseArray;
}

+(void)addPromise:(ZZPromise *)promise
{
    [[ZZPromiseQueue defaultQueue].promiseArray addObject:promise];
}

+(void)removePromise:(ZZPromise *)promise
{
    if([[ZZPromiseQueue defaultQueue].promiseArray containsObject:promise])
    {
        [[ZZPromiseQueue defaultQueue].promiseArray removeObject:promise];
    }
    
}

@end
