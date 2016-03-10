//
//  AppDelegate.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/9/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "AppDelegate.h"

#import "IHEngine.h"
#import "BBQ+ShareSDK.h"
#import "APService.h"

@interface AppDelegate ()<UINavigationControllerDelegate> {
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Engine Start
    if (![iHEngine startWithHostName:HOST_NAME byServiceRootUrl:SERVICE_ROOT_URL]) {
        return NO;
    }
    
    [self initChineseShareSDK];
    [self initWindows:application];
    
    [User sharedInstance];
    
    // JPush
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [self showTodoView];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self showTodoView];
}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Push Notification
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [NSString stringWithFormat:@"%@", deviceToken];
    [APService registerDeviceToken:deviceToken];
    
    iHDINFO(@"---- %@", [APService registrationID]);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    iHDINFO(@"收到通知1:%@", userInfo);
//    [self showTodoView];
    
    [iHPubSub publishMsgWithSubject:NH_REMOTE_NOTIFICATION_RECEIVED andDataDic:@{@"action":NH_REMOTE_NOTIFICATION_RECEIVED, @"data":userInfo}];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    iHDINFO(@"收到通知2:%@", userInfo);
//    [self showTodoView];
    
    [iHPubSub publishMsgWithSubject:NH_REMOTE_NOTIFICATION_RECEIVED andDataDic:@{@"action":NH_REMOTE_NOTIFICATION_RECEIVED, @"data":userInfo}];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)clearNotification {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [APService resetBadge];
}

#pragma mark - Chinese ShareSDK
- (void)initChineseShareSDK {
    [ShareSDK registerApp:@"9907c00a69e8"];  //如果需要看下广告效果，可以把Appkey换成"737dfd5147db"
    _interfaceOrientationMask = SSInterfaceOrientationMaskAll;
    
    //设置屏幕方向,默认是所有方向(optional)
    [ShareSDK setInterfaceOrientationMask:SSInterfaceOrientationMaskAll];
    
    [self initializePlat];
}

- (void)initializePlat {
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"596199924"
                               appSecret:@"5e43368d96702b25a0a032335ada9997"
                             redirectUri:@"http://www.ihakula.com"
                             weiboSDKCls:[WeiboSDK class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104810786"
                           appSecret:@"wINeTsix8gxGyCJn"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx375d860763d5551c"
                           appSecret:@"07ffc7fd87794171aa5e2d7efaa159bf"
                           wechatCls:[WXApi class]];
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104810786"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
}

#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

//iOS 4.2+
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - WXApiDelegate(optional)
-(void) onReq:(BaseReq*)req
{}

-(void) onResp:(BaseResp*)resp
{}

#pragma mark - other(optional)
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Class Methods
+ (AppDelegate *)getSharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Public Methods
- (void)showTodoView {
}

- (void)hideTodoView {
}

- (void)showMsg:(NSString *)message {
}

#pragma mark - Private Methods
- (void)initWindows:(UIApplication *)application {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma UINavigationControllerDelegate - Method
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //    if (navigationController.viewControllers.count>1) {
    //        [self hideTabBar];
    //    }
    //    else {
    //        [self showTabBar];
    //    }
}

@end
