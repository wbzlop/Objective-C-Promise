# OCPromise
promise tool for objective-c.
It will be executed in sequence.Avoid "callback hell".

## Sample

### import head file

```objective-c
#import "ZZPromise.h"
```
### usage
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
In "await" block you must call "resolve" function or "reject" function.
### example

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
