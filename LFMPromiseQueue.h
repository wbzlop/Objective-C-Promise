//
//  LFMPromiseQueue.h
//  ESDK
//
//  Created by wbz on 2019/1/16.
//  Copyright © 2019年 zhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFMPromise.h"
NS_ASSUME_NONNULL_BEGIN

@interface LFMPromiseQueue : NSObject


/**
 retain promise

 @param promise promise
 */
+(void)addPromise:(LFMPromise *)promise;


/**
 release promise

 @param promise promise
 */
+(void)removePromise:(LFMPromise *)promise;

@end

NS_ASSUME_NONNULL_END
