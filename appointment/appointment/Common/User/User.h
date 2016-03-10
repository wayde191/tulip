//
//  User.h
//  iFinancial
//
//  Created by Wayde Sun on 3/5/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "BBQBaseModel.h"

@interface User : BBQBaseModel {
}

@property (strong, nonatomic, readonly) NSString *token;
@property (nonatomic, assign) BOOL userClickedLogoutSucceed;

@property (nonatomic, strong) NSDictionary *userPreferedStartEndTimeDic;

@property (nonatomic, strong) NSDictionary *goodsTypeDic;
@property (nonatomic, assign) NSInteger cartFoodsNumber;
@property (nonatomic, strong) NSMutableDictionary *goodsDic;

// Class Methods
+ (User *)sharedInstance;

// Public Methods
- (void)addFood;
- (void)reduceFood;
- (void)addFoodsDic:(NSDictionary *)foods;
- (void)reduceFoodsDic:(NSDictionary *)foods;
- (void)clearGoods;
- (NSDictionary *)getTotalPrice;
- (BOOL)amiManager;
- (BOOL)isUserLoggedIn;

- (NSString *)getUserAuthStatusReadableStr;
- (NSString *)getCarAuthStatusReadableStr;

- (void)doSendAccessLog;

- (NSString *)getUserId;
- (NSString *)getGroupId;
- (NSString *)getUserName;
- (NSString *)getUserEmail;
- (NSString *)getIdCardUrl;
- (NSString *)getDriverCardUrl;
- (NSDictionary *)getContact;
- (void)updateIdCardUrl:(NSString *)idcardUrl;
- (void)updateDriverCardUrl:(NSString *)drivercardUrl;
- (NSString *)getAppKey;

- (void)updateUserName:(NSString *)uname;

- (void)updateUserContact:(NSDictionary *)contact;
- (void)loginSuccess:(NSDictionary *)uinfo;
- (void)userAuthSuccess:(NSDictionary *)authInfo;
- (void)restoreUser;
- (void)doCallLoginService;

// Cfg Methods
- (NSString *)getBasicCfgFilePath;
- (NSString *)getBrandsCfgFilePath;
- (NSString *)getBrandCarsCfgFilePath;
- (NSString *)getFaqTermFilePath;
- (NSString *)getRegisterTermFilePath;
- (NSString *)getServiceTermFilePath;
- (NSString *)getPayTermFilePath;
- (void)checkUpdates;
- (void)checkCfgUpdates; // self check

// Temporary back up user publish message
@property (nonatomic, assign) BOOL autoRecoryOpening;
@property (nonatomic, strong) NSDictionary *autoRecovryDic;

// Pubsub current page is loginviewcontroller
@property (nonatomic, weak) id publishMessageRcvCurrentPageIsLoginVC;

// Test Methods
- (void)setDriverValidatedTesting;

@end
