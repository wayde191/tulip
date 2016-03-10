//
//  BBQ+ShareSDK.h
//  BBQ
//
//  Created by Wei Wayde Sun on 8/14/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#ifndef BBQ_BBQ_ShareSDK_h
#define BBQ_BBQ_ShareSDK_h

#import <ShareSDK/ShareSDK.h>

//第三方平台的SDK头文件，根据需要的平台导入。
//以下分别对应微信、新浪微博
#import "WXApi.h"
#import "WeiboSDK.h"
//以下是腾讯QQ和QQ空间
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//开启QQ和Facebook网页授权需要
#import <QZoneConnection/ISSQZoneApp.h>

#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/NSString+Common.h>

#define CONTENT NSLocalizedString(@"TEXT_SHARE_CONTENT", @"ShareSDK不仅集成简单、支持如QQ好友、微信、新浪微博、腾讯微博等所有社交平台，而且还有强大的统计分析管理后台，实时了解用户、信息流、回流率、传播效应等数据，详情见官网http://sharesdk.cn @ShareSDK")
#define SHARE_URL @"http://www.mob.com"

#endif
