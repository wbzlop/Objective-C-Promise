# OCPromise


接触Javascript后觉得 promise 非常好用，iOS项目开发SDK过程中初始化流程涉及到多个异步回调嵌套，所以使用block特性，写了一个promise工具，优化初始化流程，避免“callback hell”，提高代码可读性。
## Sample

### Import head file

```objective-c
#import "ZZPromise.h"
```
### Usage
```objective-c
ZZPromise.promise().await(^(Resolve resolve, Reject reject) {
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

### Example

```objective-c
    __weak typeof(self) weakSelf = self;
    ZZPromise.promise().await(^(Resolve resolve, Reject reject) {
        
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
        
    }).catch(^(NSError *error) {
        
        NSLog(@"init failed:%@",error.localizedDescription)
        
    }).final(^{
        NSLog(@"init complete!");
    });
```

   
