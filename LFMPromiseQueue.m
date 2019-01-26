//
//  LFMPromiseQueue.m
//  ESDK
//
//  Created by wbz on 2019/1/16.
//  Copyright © 2019年 zhizhen. All rights reserved.
//

#import "LFMPromiseQueue.h"

@interface LFMPromiseQueue()

@property (nonatomic,strong)NSMutableArray<LFMPromise *> *promiseArray;

@end

@implementation LFMPromiseQueue

+(instancetype)defaultQueue
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray<LFMPromise *> *)promiseArray
{
    if(_promiseArray == nil)
    {
        _promiseArray = [NSMutableArray array];
    }
    return _promiseArray;
}

+(void)addPromise:(LFMPromise *)promise
{
    [[LFMPromiseQueue defaultQueue].promiseArray addObject:promise];
}

+(void)removePromise:(LFMPromise *)promise
{
    if([[LFMPromiseQueue defaultQueue].promiseArray containsObject:promise])
    {
        [[LFMPromiseQueue defaultQueue].promiseArray removeObject:promise];
    }
    
}

@end
