//
//  JBaseModel.h
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHBaseModel.h"

@interface BBQBaseModel : iHBaseModel

- (NSInteger)getRandomNumber:(int)from to:(int)to;

- (BOOL)doCallService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate;
- (BOOL)doCallHttpService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate;

- (void)showMessage:(NSString *)msg;
- (void)hideMessage;

- (NSString *)md5Sign:(NSDictionary *)paras;
- (NSString *)getTimetamp;

- (NSString *)getOrderStatus:(NSString *)status;
- (NSString *)getCarLimitStatus:(NSString *)status;

- (void)cancelAllRequest;
- (NSString *)getCancelRequestSubjectTitleWithServiceName:(NSString *)serviceName;

@end
