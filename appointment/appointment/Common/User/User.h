//
//  User.h
//  iFinancial
//
//  Created by Wayde Sun on 3/5/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "BBQBaseModel.h"
#import <CoreLocation/CoreLocation.h>

@interface User : BBQBaseModel {
    NSString *_address;
}

@property (strong, nonatomic, readonly) NSString *token;
@property (nonatomic, assign) BOOL userClickedLogoutSucceed;

@property (nonatomic, strong) NSDictionary *userPreferedStartEndTimeDic;

@property (nonatomic, strong) NSArray *dynamicMenuArr;
@property (nonatomic, strong) NSDictionary *adDic;

@property(strong, nonatomic) CLLocation *myLocation;

- (NSString *)getUUID;
- (NSString *)getAddress;
- (void)uploadLocation;
- (void)uploadDeviceId;

// Class Methods
+ (User *)sharedInstance;

// Public Methods
- (NSString *)getAppKey;

- (void)loginSuccess:(NSDictionary *)uinfo;
- (void)restoreUser;

@end
