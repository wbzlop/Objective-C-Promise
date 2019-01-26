//
//  LFMPromise.h
//  LFMediation
//
//  Created by wbz on 2019/1/11.
//  Copyright © 2019年 LeFei. All rights reserved.
// NOTICE:非线程安全，queue增删操作有可能导致异常
//

#import <Foundation/Foundation.h>
@class LFMPromise;



typedef void(^Resolve)(id param);
typedef void(^Reject)(NSError *error);

typedef void(^Next)(NSInteger index);// for recursive
typedef void(^Break)(void);//for recursive


typedef void(^Promise)(Resolve resolve,Reject reject);
typedef void(^Enumerate)(NSInteger index,Next nextBlock,Break breakBlock);

typedef LFMPromise *(^Catch)(Reject reject);
typedef LFMPromise *(^Then)(Resolve resolveBlock);
typedef LFMPromise *(^Await)(Promise promiseBlock);
typedef LFMPromise *(^Recursive)(Enumerate enumerateBlock);
typedef void(^Final)(dispatch_block_t finalBlock);
typedef LFMPromise *(^PromiseChain)(void);

@interface LFMPromise : NSObject

@property (nonatomic,copy,readonly)Then then;
@property (nonatomic,copy,readonly)Catch catch;
@property (nonatomic,copy,readonly)Await await;
@property (nonatomic,copy,readonly)Final final;
@property (nonatomic,copy,readonly)Recursive recursive;


+(PromiseChain)promise;
@end


