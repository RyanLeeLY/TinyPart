# TinyPart
TinyPart is an iOS modularization framework coding by Ojective-C. It also support URL router and inter-module communication. [中文文档](https://github.com/RyanLeeLY/TinyPart/blob/master/README-zhCN.md)
## Installation
### cocoapods

```ruby
pod 'TinyPart'
```

## Features
* **Protocol-oriented** Modules and services in Tinypart are protocol-oriented. The advantage is that maintenance interface will be much more easier, and any interface changes are visible at compile time. However, large projects may face a large number of protocols that need to be maintained. This is a disadvantage that cannot be ignored.

* **Dynamic** The registration of modules and services in TinyPart is done at runtime. You can adjust the registration and startup time of the module according to specific needs. The asynchronous startup will help optimize the first-screen-loading of the APP.

* **Routing-service** We know that protocol-oriented services are convenient for maintaining interface. However, when modules call other's services, they need to know each other's protocols. In the end, all protocols may need to be exposed to all modules. For example, there are 10 modules and 1 service protocol per module. In the above case, each module needs to know the protocol of another 9 modules. This means that each protocol is imported 9 times, and all protocols will be imported 9*10=90 times in total, this is a nightmare for modularization who want code isolation. Routing-service is a good balance between the inter-module calls and dependencies, and by the way also solve the cross-APP jump problem.

* **URL-routing** On the basis of routing-service, simply adding another one or two lines of code can implement the URL-routing through APPScheme.

* **Multi-level Directive Communication** In general, there are two ways of inter-module communication for decoupling: URL and notifications ```NSNotification```. URL solves the problem of inter-module services calling, but they may become very complicated if you want to implement an observer-pattern by URL. At this time, people may prefer to select notifications, but since the notifications are global, this will cause any one of the notifications can be used by any module in the APP. As time went by, these notifications will be difficult to maintain. <br>The so-called multi-level directive communication, is based on the ```NSNotification``` to limit the propagation direction of the notifications. The notification being dispatched from underlying modules to upper modules that called ```Broadcast```. The notification being dispatched from upper modules to underlying or same-level modules that called ```Report```. This has two advantages: on the one hand, more beneficial to the maintenance of the notification, on the other hand can help us to divide the module level. For example, if we find that a module needs to ```Report``` to so many modules, then this module should probably be divided into a lower-level modules.

## Architecture
![Architecture](https://github.com/RyanLeeLY/TinyPart/blob/master/TinyPart.jpeg)

## Usage
### Setup
* AppDelegate inherits TPAppDelegate, and initialize the TPContext

```Objective-C
#import "TinyPart.h"

@interface AppDelegate : TPAppDelegate
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TPMediator sharedInstance].deleagate = self;

    [TPContext sharedContext].launchOptions = launchOptions;
    [TPContext sharedContext].application = application;
    [TinyPart sharedInstance].context = [TPContext sharedContext];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

### Module
* **Defination And Registration**

```Objective-C
#import "TinyPart.h"

@interface TestModule1 : NSObject <TPModuleProtocol>
@end

@implementation TestModule1
TP_MODULE_AUTO_REGISTER // Module will be registered in "+load" method

TP_MODULE_ASYNC         // Aysnc load

TP_MODULE_PRIORITY(1)   // Priority of the module. The higher will be launched in higher priority.

TP_MODULE_LEVEL(TPModuleLevelBasic)     // Level of the module

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)moduleDidLoad:(TPContext *)context {
    switch (context.env) {
        case TPRunningEnviromentTypeDebug: {
            NSLog(@"%@", @"TestModule1 moduleDidLoad: debug");
            break;
        }
        case TPRunningEnviromentTypeRelease: {
            NSLog(@"%@", @"TestModule1 moduleDidLoad: release");
            break;
        }
    }
}
@end
```

### Service
* **Defination And Registration** Service can be singleton or multiple partterns。

```Objective-C
#import "TPServiceProtocol.h"

@protocol TestModuleService1 <TPServiceProtocol>
- (void)function1;
@end

@interface TestModuleService1Imp : NSObject <TestModuleService1>
@end

@implementation TestModuleService1Imp
TPSERVICE_AUTO_REGISTER(TestModuleService1) // Service will be registered in "+load" method

- (void)function1 {
    NSLog(@"%@", @"TestModuleService1 function1");
}
@end
```
* **Call Sevice**

```Objective-C
id<TestModuleService1> service1 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService1"];
    [service1 function1];
```

### Router
* **Defination And Registration**

```Objective-C
#import "TPRouter.h"

@interface TestRouter : TPRouter
@end
#import "TinyPart.h"

@implementation TestRouter
TPROUTER_AUTO_REGISTER  // Router will be registered in "+load" method

// Authentication required in APP. You also need to implement TPMediatorDelegate's method.
TPRouter_AUTH_REQUIRE(@"action1", @"action2")

TPROUTER_METHOD_EXPORT(action1, {
    NSLog(@"TestRouter action1 params=%@", params);
    return nil;
});

TPROUTER_METHOD_EXPORT(action2, {
    NSLog(@"TestRouter action2 params=%@", params);
    return nil;
});
@end
```
* **Open Router**

```Objective-C
[[TPMediator sharedInstance] performAction:@"action1" router:@"Test" params:@{}];
```

### URL Routing
* **Add A ConfigPlistFile** 
```TinyPart.bundle/TinyPart.plist```is```context.configPlistFileName ```'s default value.

```Objective-C
TPContext *context = [TPContext sharedContext];
context.configPlistFileName = @"TinyPart.bundle/TinyPart.plist";
[TinyPart sharedInstance].context = context;
```
* **New**```TinyPart.bundle/TinyPart.plist```, and add a **URL Scheme**

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>APPURLSchemes</key>
	<array>
		<string>tinypart</string>
	</array>
</dict>
</plist>
```

* **Defination of URL-routing** On the basic of```TestRouter```, we only need to do is creating file ```TPMediator+Test``` and add the codes like below.

```Objective-C
@implementation TPMediator (Test)
+ (void)load {
    // The host "com.tinypart.test" corresponding to TestRouter
    TPURLHostForRouter(@"com.tinypart.test", TestRouter) // tinypart://com.tinypart.test
    
	 // The path "/action1" corresponding to TestRouter's action1
    TPURLPathForActionForRouter(@"/action1", action1, TestRouter);  // tinypart://com.tinypart.test/action1
}
@end
```
* **Open URL**

```Objective-C
NSURL *url = [NSURL URLWithString:@"tinypart://com.tinypart.test/action1?id=1&name=tinypart"];
[[TPMediator sharedInstance] openURL:url];
```

### Directive Communication
* **Send** Here's a note of what was mentioned above: The notification being dispatched from underlying modules to upper modules that called ```Broadcast```. The notification being dispatched from upper modules to underlying or same-level modules that called ```Report```. There are three levels **Basic、Middle、Topout** defined in TinyPart。

```Objective-C
TPNotificationCenter *center2 = [TestModule2 tp_notificationCenter];

[center2 reportNotification:^(TPNotificationMaker *make) {
    make.name(@"report_notification_from_TestModule2");
} targetModule:@"TestModule1"];
    
[center2 broadcastNotification:^(TPNotificationMaker *make) {
	make.name(@"broadcast_notification_from_TestModule2").userInfo(@{@"key":@"value"}).object(self);
}];
```

* **Receive**

```Objective-C
TPNotificationCenter *center1 = [TestModule1 tp_notificationCenter];
// Observer will be dealloc automatically
[center1 addObserver:self selector:@selector(testNotification:) name:@"report_notification_from_TestModule2" object:nil];
```

## Reference
[**BeeHive**](https://github.com/alibaba/BeeHive)

[**ReactNative**](http://facebook.github.io/react-native/)

## License
TinyPart is available under the MIT license. See the [LICENSE](https://github.com/RyanLeeLY/TinyPart/blob/master/LICENSE) file for more info.