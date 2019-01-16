//
//  ZZPromiseQueue.h
//  ESDK
//
//  Created by wbz on 2019/1/16.
//  Copyright © 2019年 zhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPromise.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZZPromiseQueue : NSObject


/**
 retain promise

 @param promise promise
 */
+(void)addPromise:(ZZPromise *)promise;


/**
 release promise

 @param promise promise
 */
+(void)removePromise:(ZZPromise *)promise;

@end

NS_ASSUME_NONNULL_END
