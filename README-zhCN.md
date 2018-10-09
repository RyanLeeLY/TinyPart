# TinyPart
TinyPart是一个由Objective-C编写的面向协议的iOS模块化框架，同时它还支持URL路由和模块间通信机制。
## 安装
### cocoapods

```ruby
pod 'TinyPart'
```

## 特点
* **面向协议**。TinyPart中模块和服务都是面向协议的。服务面向协议的好处在于对于接口维护比较友好，任何接口的变动在编译时都是可见的，但是大型项目有可能会面临大量需要维护的协议，这也是不可忽视的缺点。

* **动态化**。TinyPart中模块和服务的注册都是在运行时完成的，可以根据具体需要调整模块的注册和启动时间，异步启动模块对于优化APP首屏加载时间会有帮助。

* **路由服务**。我们知道面向协议的服务虽然对于接口维护比较方便，但是模块间相互调用各自服务，是需要知道对方协议的，这样最后可能会导致所有的协议需要暴露给所有的模块。比如现在有10个模块每个模块有1个服务协议，在上述情况下每个模块需要知道另外9个模块的协议，这相当于每个协议都被@import了9次，所有协议总共将会被@import 9*10=90次，这对于想做完全代码隔离的模块化来说是个噩梦。通过路由服务则很好地平衡了模块间调用和依赖问题，顺便也解决了跨APP跳转的问题。

* **URL路由**。在路由基础上，只需要再增加简单的1到2行代码就可以实现通过APPScheme的URL路由机制。

* **多级模块有向通信**。一般来说，完全去耦合的模块间通信方案大概是两种：URL和通知```NSNotification```。URL解决了模块间服务相互调用的问题，但是如果想要通过URL实现一个观察者模式则会变得非常复杂。这时候大家可能会偏向于选择通知，但是由于通知是全局性的，这样会导致任何一条通知可能会被APP内任何一个模块所使用，久而久之这些通知会变得难以维护。<br>所谓**多级模块有向通信**，则是在```NSNotification```基础上对通知的传播方向进行了限制，底层模块对上层模块的通知称为**广播**```Broadcast```，上层模块对底层模块或者同层模块的通知称为**上报**```Report```。这样做有两个好处：一方面更利于通知的维护，另一方面可以帮助我们划分模块层级，如果我们发现有一个模块需要向多个同级模块进行```Report```那么这个模块很有可能应该被划分到更底层的模块。

## 架构说明
![架构图](https://github.com/RyanLeeLY/TinyPart/blob/master/TinyPart.jpeg)

## 用法
### 初始化
* 继承 TPAppDelegate，初始化TPContext

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
    context.configPlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.modulePlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.servicePlistFileName = @"TinyPart.bundle/TinyPart.plist";
    context.routerPlistFileName = @"TinyPart.bundle/TinyPart.plist";
    [TinyPart sharedInstance].context = [TPContext sharedContext];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

* 新建plist文件'TinyPart.bundle/TinyPart.plist'

![create_plist](https://github.com/RyanLeeLY/TinyPart/blob/master/Pics/create_plist.jpeg)

### 模块Module
* **定义并注册一个模块**

```Objective-C
#import "TinyPart.h"

@interface TestModule : NSObject <TPModuleProtocol>
@end

@implementation TestModule
TP_MODULE_AUTO_REGISTER // 自动注册模块，动态注册模块

TP_MODULE_ASYNC         // 异步启动模块，优化开屏性能

TP_MODULE_PRIORITY(1)   // 模块启动优先级，优先级高的先启动

TP_MODULE_LEVEL(TPModuleLevelBasic)     // 模块级别：基础模块

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

如果没有使用`TP_MODULE_AUTO_REGISTER `自动注册宏的话，还需要将TestModule1加到`TinyPart.plist`配置文件中。

![register_module](https://github.com/RyanLeeLY/TinyPart/blob/master/Pics/register_module.jpeg)

### 服务Service用法
* **定义并注册一个服务Service**。Service可自定义单例模式或多例模式。

```Objective-C
#import "TPServiceProtocol.h"

@protocol TestModuleService1 <TPServiceProtocol>
- (void)function1;
@end

@interface TestModuleService1Imp : NSObject <TestModuleService1>
@end

@implementation TestModuleService1Imp
TPSERVICE_AUTO_REGISTER(TestModuleService1) // 自动注册服务

- (void)function1 {
    NSLog(@"%@", @"TestModuleService1 function1");
}
@end
```

如果没有使用`TPSERVICE_AUTO_REGISTER `自动注册宏的话，还需要将TestModuleService1加到`TinyPart.plist`配置文件中。

![register_service](https://github.com/RyanLeeLY/TinyPart/blob/master/Pics/register_service.jpeg)

* **访问服务Sevice**

```Objective-C
id<TestModuleService1> service1 = [[TPServiceManager sharedInstance] serviceWithName:@"TestModuleService1"];
    [service1 function1];
```

### 路由Router用法
* **定义并注册一个路由Router**

```Objective-C
#import "TPRouter.h"

@interface TestRouter : TPRouter
@end
#import "TinyPart.h"

@implementation TestRouter
TPROUTER_AUTO_REGISTER  // 自动注册路由

// APP身份验证，需要实现TPMediatorDelegate中的身份验证回调
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

如果没有使用`TPROUTER_AUTO_REGISTER`自动注册宏的话，还需要将TestModuleService1加到`TinyPart.plist`配置文件中。

![register_router](https://github.com/RyanLeeLY/TinyPart/blob/master/Pics/register_router.jpeg)

* **使用路由Router**

```Objective-C
[[TPMediator sharedInstance] performAction:@"action1" router:@"Test" params:@{}];
```

### URL路由

* **新建**```TinyPart.bundle/TinyPart.plist```，并注册一条**URL Scheme**

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

* **定义一条URL路由规则**。在已有的```TestRouter```基础上，我们只需要新建一个```TPMediator+Test```的扩展。

```Objective-C
@implementation TPMediator (Test)
+ (void)load {
    // 声明TestRouter对应的Host
    TPURLHostForRouter(@"com.tinypart.test", TestRouter) // tinypart://com.tinypart.test
    
    // 声明TestRouter中action1对应的Path
    TPURLPathForActionForRouter(@"/action1", action1, TestRouter);  // tinypart://com.tinypart.test/action1
}
@end
```
* **使用URL路由**

```Objective-C
NSURL *url = [NSURL URLWithString:@"tinypart://com.tinypart.test/action1?id=1&name=tinypart"];
[[TPMediator sharedInstance] openURL:url];
```

### 有向通信
* **发送**。这里注意前面提到的，底层模块对上层模块的通知称为**广播**```Broadcast```，上层模块对底层模块或者同层模块的通知称为**上报**```Report```。模块级别分为**Basic、Middle、Topout**三个级别。

```Objective-C
TPNotificationCenter *center2 = [TestModule2 tp_notificationCenter];

[center2 reportNotification:^(TPNotificationMaker *make) {
    make.name(@"report_notification_from_TestModule2");
} targetModule:@"TestModule1"];
    
[center2 broadcastNotification:^(TPNotificationMaker *make) {
	make.name(@"broadcast_notification_from_TestModule2").userInfo(@{@"key":@"value"}).object(self);
}];
```

* **接收**

```Objective-C
TPNotificationCenter *center1 = [TestModule1 tp_notificationCenter];
// Observer销毁后自动释放
[center1 addObserver:self selector:@selector(testNotification:) name:@"report_notification_from_TestModule2" object:nil];
```

## 参考项目
[**BeeHive**](https://github.com/alibaba/BeeHive)

[**ReactNative**](http://facebook.github.io/react-native/)

## 开源许可证
TinyPart is available under the MIT license. See the [LICENSE](https://github.com/RyanLeeLY/TinyPart/blob/master/LICENSE) file for more info.