//
//  LFMPromise.m
//  LFMediation
//
//  Created by wbz on 2019/1/11.
//  Copyright © 2019年 LeFei. All rights reserved.
//

#import "LFMPromise.h"
#import "LFMPromiseQueue.h"
@interface LFMPromise()

@property (nonatomic,copy)Then then;
@property (nonatomic,copy)Catch catch;
@property (nonatomic,copy)Await await;
@property (nonatomic,copy)Final final;
@property (nonatomic,copy)Recursive recursive;
@property (nonatomic,strong)NSMutableArray<Resolve> *resolvedArr;
@property (nonatomic,strong)NSMutableArray<Promise> *promiseArr;
@property (nonatomic,strong)NSMutableArray<Enumerate> *recursiveArr;

//0:resolve 1:promise 2:recursive
@property (nonatomic,strong)NSMutableArray<NSNumber *> *actionArr;


@property (nonatomic,copy)Resolve executeResolveBlock;
@property (nonatomic,copy)Reject executeRejectBlock;

@property (nonatomic,copy)Next executeNextBlock;
@property (nonatomic,copy)Break executeBreakBlock;

@property (nonatomic,copy)Reject currentRejectBlcok;
@property (nonatomic,copy)dispatch_block_t finalBlock;

@property (nonatomic,assign)BOOL isRunning;

@end

@implementation LFMPromise

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        _resolvedArr = [NSMutableArray new];
        _promiseArr = [NSMutableArray new];
        _actionArr = [NSMutableArray new];
        _recursiveArr = [NSMutableArray new];
        _executeResolveBlock =^(id param){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf excute:param];
            });
        };
        
        _executeRejectBlock =^(NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf.currentRejectBlcok != nil)
                {
                    weakSelf.currentRejectBlcok(error);
                }
                
                if(weakSelf.finalBlock)
                {
                    weakSelf.finalBlock();
                }
            });
        };
        
        //when call next
        _executeNextBlock =^(NSInteger index){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf excute:@(index)];
            });
        };
        //when call break
        _executeBreakBlock =^(){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.recursiveArr removeObjectAtIndex:0];
                [weakSelf.actionArr removeObjectAtIndex:0];
                [weakSelf excute:nil];
            });
        };
        
        
        _isRunning = false;
        
    }
    return self;
}



-(void)excute:(id)param
{
    if([self.actionArr count] > 0)
    {
        NSInteger type = [self.actionArr[0] integerValue];
        if(type == 0)
        {
            self.resolvedArr[0](param);
            [self.resolvedArr removeObjectAtIndex:0];
            [self.actionArr removeObjectAtIndex:0];
            [self excute:param];
            
        }
        else if(type == 1)
        {
            self.promiseArr[0](self.executeResolveBlock,self.executeRejectBlock);
            [self.promiseArr removeObjectAtIndex:0];
            [self.actionArr removeObjectAtIndex:0];
        }
        else
        {
            self.recursiveArr[0]([param integerValue],self.executeNextBlock,self.executeBreakBlock);
        }
    }
    else
    {
        if(_finalBlock)
        {
            _finalBlock();
        }
        _isRunning = NO;
        
        [LFMPromiseQueue removePromise:self];
       
    }
}

-(Then)then
{
    if(!_then)
    {
        __weak typeof(self) weakSelf = self;
        _then = ^(Resolve param)
        {
    
            [weakSelf.resolvedArr addObject:param];
            [weakSelf.actionArr addObject:@(0)];
            
            
            return weakSelf;
        };
    }

    return _then;
}

-(Catch)catch
{
    if(!_catch)
    {
        __weak typeof(self) weakSelf = self;
        _catch = ^(Reject reject)
        {
            weakSelf.currentRejectBlcok =  reject;
            return weakSelf;
        };
        

    }
    
    return _catch;
}

-(Await)await
{
    if(!_await)
    {
        __weak typeof(self) weakSelf = self;
        _await = ^(Promise promiseBlock)
        {
            
            
            if(!weakSelf.isRunning)
            {
                weakSelf.isRunning = YES;
                promiseBlock(weakSelf.executeResolveBlock,weakSelf.executeRejectBlock);
                
            }
            else
            {
                [weakSelf.promiseArr addObject:promiseBlock];
                [weakSelf.actionArr addObject:@(1)];
            }
            
            
            return weakSelf;
        };
        

    }
    return _await;
}


-(Final)final
{
    if(!_final)
    {
         __weak typeof(self) weakSelf = self;
        _final = ^(dispatch_block_t finalBlock){
            weakSelf.finalBlock = finalBlock;
        };
    }
    
    return _final;
}

-(Recursive)recursive
{
    if(!_recursive)
    {
        __weak typeof(self) weakSelf = self;
        _recursive = ^(Enumerate enumerateBlock)
        {
            
            if(!weakSelf.isRunning)
            {
                weakSelf.isRunning = YES;
                enumerateBlock(0,weakSelf.executeNextBlock,weakSelf.executeBreakBlock);
                [weakSelf.recursiveArr addObject:enumerateBlock];
                [weakSelf.actionArr addObject:@(2)];
              
            }
            else
            {
                [weakSelf.recursiveArr addObject:enumerateBlock];
                [weakSelf.actionArr addObject:@(2)];
            }
            
            return weakSelf;
        };
        
    }
    
    return _recursive;
}

+(PromiseChain)promise
{
    LFMPromise *instance = [[LFMPromise alloc] init];
    
    __weak LFMPromise *weakSelf = instance;
    PromiseChain block = ^(){
        return weakSelf;
    };
    //持有引用
    [LFMPromiseQueue addPromise:instance];
    return block;
}

@end
