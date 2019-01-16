//
//  ZZPromise.h
//  LFMediation
//
//  Created by wbz on 2019/1/11.
//  Copyright © 2019年 LeFei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZPromise;



typedef void(^Resolve)(id param);
typedef void(^Reject)(NSError *error);

typedef void(^Promise)(Resolve resolve,Reject reject);

typedef ZZPromise *(^Catch)(Reject reject);
typedef ZZPromise *(^Then)(Resolve resolveBlock);
typedef ZZPromise *(^Await)(Promise promiseBlock);
typedef void(^Final)(dispatch_block_t finalBlock);
typedef ZZPromise *(^PromiseChain)(void);

@interface ZZPromise : NSObject

@property (nonatomic,copy,readonly)Then then;
@property (nonatomic,copy,readonly)Catch catch;
@property (nonatomic,copy,readonly)Await await;
@property (nonatomic,copy,readonly)Final final;



+(PromiseChain)promise;
@end


