# Objective-C Promise

接触Javascript后觉得 promise 非常好用，iOS项目开发SDK过程中初始化流程涉及到多个异步回调嵌套，所以使用block特性，写了一个promise工具，优化初始化流程，避免“callback hell”，提高代码可读性。
## Sample

### Import head file

```objective-c
#import "LFMPromise.h"
```
### Usage

#### await

处理异步回调

```objective-c
LFMPromise.promise().await(^(Resolve resolve, Reject reject) {
        resolve(nil);
    }).await(^(Resolve resolve, Reject reject) {
        resolve(nil);
    }).then(^(id param) {
        
    }).catch(^(NSError *error) {
        
    }).final(^{
        
    });
```
在"await"中必须调用"resolve"或者"reject"。
resolve使流程继续向下执行，reject直接跳到catch然后final(如果有的话)。

#### recursive

处理递归

```
LFMPromise.promise().recursive(^(NSInteger index, Next nextBlock, Break breakBlock) {
        
    });

```

index:递归次数

nextBlock：继续执行递归

breakBlock：跳出递归

### Example

```objective-c
    __weak typeof(self) weakSelf = self;
    LFMPromise.promise().await(^(Resolve resolve, Reject reject) {
        //登陆
        [[NetworkHelper defalutHelper] login:^(BOOL success, NSError *error) {
            if(success)
            {
                resolve(nil);
            }
            else
            {
                reject(error);
            }
        }];
        
    }).await(^(Resolve resolve, Reject reject) {
        //从服务器获取信息
        [[NetworkHelper defalutHelper] fetchInfo:^(BOOL success, NSDictionary *returnDict,NSError *error) {
            if(success)
            {
                resolve(returnDict);
            }
            else
            {
                reject(error);
            }
        }];
        
    }).then(^(id param) {
        
        [weakSelf layoutUI];
        
    }).recursive(^(NSInteger index, Next nextBlock, Break breakBlock) {
        //遍历可用广告
        if([set.list count] > index)
        {
            index++;
            LFMAdWrapper *ad = set.list[index];
            [ad fetchWithComplete:^ (BOOL success, LFMAdWrapper * _Nonnull adWrapper) {
                
                if(success)
                {
                    //广告可用
                    breakBlock();
                }
                else
                {
                    //当前广告不可用，继续递归
                    nextBlock(index);
                }
            }];
        }
        else
        {
            breakBlock();
        }

    })catch(^(NSError *error) {
        
        NSLog(@"init failed:%@",error.localizedDescription)
        
    }).final(^{
        NSLog(@"init complete!");
    });
```
