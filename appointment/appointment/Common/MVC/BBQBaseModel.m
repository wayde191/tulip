//
//  JBaseModel.m
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "BBQBaseModel.h"
#import "AppDelegate.h"

@implementation BBQBaseModel

- (NSString *)getOrderStatus:(NSString *)status {
    NSString *readableString = nil;
    switch ([status intValue]) {
        case 0:
            readableString = NH_ORDER_STATUS_0;
            break;
        case 1:
            readableString = NH_ORDER_STATUS_1;
            break;
        case 2:
            readableString = NH_ORDER_STATUS_2;
            break;
        case 3:
            readableString = NH_ORDER_STATUS_3;
            break;
        case 4:
            readableString = NH_ORDER_STATUS_4;
            break;
        case 5:
            readableString = NH_ORDER_STATUS_5;
            break;
        case 6:
            readableString = NH_ORDER_STATUS_6;
            break;
        case 7:
            readableString = NH_ORDER_STATUS_7;
            break;
        case 8:
            readableString = NH_ORDER_STATUS_8;
            break;
        case 9:
            readableString = NH_ORDER_STATUS_9;
            break;
        case 10:
            readableString = NH_ORDER_STATUS_10;
            break;
            
        default:
            break;
    }
    
    return readableString;
}

- (NSString *)getCarLimitStatus:(NSString *)status {
    NSString *readableString = nil;
    switch ([status intValue]) {
        case 0:
            readableString = MK_LIMIT_STATUS_0;
            break;
        case 1:
            readableString = MK_LIMIT_STATUS_1;
            break;
        case 2:
            readableString = MK_LIMIT_STATUS_2;
            break;
        case 3:
            readableString = MK_LIMIT_STATUS_3;
            break;
        case 4:
            readableString = MK_LIMIT_STATUS_4;
            break;
        case 5:
            readableString = MK_LIMIT_STATUS_5;
            break;
        case 6:
            readableString = MK_LIMIT_STATUS_6;
            break;
        case 7:
            readableString = MK_LIMIT_STATUS_7;
            break;
        case 8:
            readableString = MK_LIMIT_STATUS_8;
            break;
        case 9:
            readableString = MK_LIMIT_STATUS_9;
            break;
            
        default:
            break;
    }
    
    return readableString;
}

- (NSString *)md5Sign:(NSDictionary *)postParasDic {
    NSMutableString *paras = [NSMutableString stringWithString:[[User sharedInstance] getAppKey]];
    for (NSString *key in postParasDic) {
        NSString *value = postParasDic[@"key"];
        [paras appendFormat:@"%@+%@",key, value];
    }
    
    return [paras md5];
}

- (NSString *)getTimetamp {
    NSDate *currentNow = [NSDate date];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy-MM-dd HH:mm"];

    return [dateFormatte stringFromDate:currentNow];
}

- (NSInteger)getRandomNumber:(int)from to:(int)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)showAlertTestingMessage:(NSString *)msg withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Rewrite super methods
- (BOOL)doCallService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate {
    
//    NSString *strParas = [iHArithmeticKit getStringFromDictionary:paraDic];
//    strParas = [strParas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    if (TESTING_SWITCH_ON) {
//        [self showAlertTestingMessage:strParas withTitle:[NSString stringWithFormat:@"%@-%@", serviceName, @"参数"]];
//    }
//    
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    NSMutableString *sign = [NSMutableString string];
//    BOOL first = YES;
//    
//    // Paras
//    if (strParas) {
//        first = NO;
//        [sign appendString:[NSString stringWithFormat:@"params=%@", strParas]];
//        [paras setValue:strParas forKey:@"params"];
//    }
//    
//    // Timestamp
//    NSString *timestamp = [iHArithmeticKit getCurrentTimetamp];
//    if (first) {
//        first = NO;
//        [sign appendString:[NSString stringWithFormat:@"timestamp=%@", timestamp]];
//    } else {
//        [sign appendString:[NSString stringWithFormat:@"&timestamp=%@", timestamp]];
//    }
//    [paras setValue:timestamp forKey:@"timestamp"];
//    
//    //token
//    NSString *token = [User sharedInstance].token;
//    if (token) {
//        [sign appendString:[NSString stringWithFormat:@"&token=%@", token]];
//    }
//    
//    // Appkey
//    [sign appendString:[NSString stringWithFormat:@"&%@", [[User sharedInstance] getAppKey]]];
//    NSString *utf8Sign = [NSString stringWithCString:[[NSString stringWithFormat:@"%@", sign] UTF8String] encoding:NSUTF8StringEncoding];
//
//    NSString *theMD5Sign = [utf8Sign md5];
//    [paras setValue:theMD5Sign forKey:@"sign"];
//    
//    iHDINFO(@"================\nsign: %@ \n", utf8Sign);
//    iHDINFO(@"================\nsign-md5: %@ \n", theMD5Sign);
    
    if ([super doCallService:serviceName
              withParameters:paraDic
               andServiceUrl:serviceUrl forDelegate:theDelegate]) {
        
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showNetworkIssue)]) {
            [self.delegate performSelector:@selector(showNetworkIssue) withObject:nil afterDelay:0.0];
        }
    }
    return YES;
}

- (BOOL)doCallHttpService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate {
    if ([super doCallHttpService:serviceName withParameters:paraDic andServiceUrl:serviceUrl forDelegate:theDelegate]) {
        [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"RequestSending")];
    } else {
        [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork")];
        [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
    }
    
    return YES;
}

- (void)showMessage:(NSString *)msg {
//    AppDelegate *appDelegate = [AppDelegate getSharedAppDelegate];
//    [appDelegate showMsg:msg];
}

- (void)hideMessage {
//    AppDelegate *appDelegate = [AppDelegate getSharedAppDelegate];
//    [appDelegate hideMsg];
}

#pragma mark - iHRequestDelegate
- (void)requestDidStarted {
    // Should be rewritten by subclass
}

- (void)requestDidCanceld {
    [super requestDidCanceld];
    [self showMessage:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"RequestCanceled")];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:1.3];
}

- (void)requestDidFinished:(iHResponseSuccess *)response {
    if (TESTING_SWITCH_ON) {
        NSString *strParas = [iHArithmeticKit getStringFromDictionary:response.userInfoDic];
        strParas = [strParas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showAlertTestingMessage:strParas withTitle:[NSString stringWithFormat:@"%@-%@", response.serviceName, @"response"]];
    }
    
    switch ([response.status intValue]) {
        case SERVICE_OPERATION_SUCC:
            [self serviceCallSuccess:response];
            break;
        default:
            [self serviceCallFailed:response];
            break;
    }
}

- (void)requestDidFailed:(iHResponseFailure *)response {
//    if ([response.serviceName isEqualToString:@"LPLoginService"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:response.errorInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [self hideMessage];
//    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hideMessage)]) {
            [self.delegate performSelector:@selector(hideMessage) withObject:nil afterDelay:.0];
//            [self.delegate performSelector:@selector(showErrorMessage:) withObject:response.errorCode afterDelay:.0];
        }
//    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)cancelAllRequest {
    
}

- (NSString *)getCancelRequestSubjectTitleWithServiceName:(NSString *)serviceName {
    return [NSString stringWithFormat:@"%@Canceld", serviceName];
}

- (void)gotoLoginViewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideMessage)]) {
        [self.delegate performSelector:@selector(hideMessage) withObject:nil afterDelay:.0];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginViewController)]) {
        [self.delegate performSelector:@selector(gotoLoginViewController) withObject:nil afterDelay:0.0];
    }
}

#pragma mark - Service call finished result handler
- (void)serviceCallFailed:(iHResponseSuccess *)response {
    
    NSString *msg = @"";
    switch ([response.errorCode intValue]) {
        case 1: // not login
        {
        if ([response.errMsg isEqualToString:@"password error"]) {
            msg = @"密码错误";
        } else {
            msg = @"参数错误";
        }
        }
            break;
        case 2: // alert
            [self showAlertTestingMessage:response.errMsg withTitle:@""];
            break;
        case 3: // 签名验证失败 , token 失效
        {
            [self gotoLoginViewController];
            msg = @"签名验证失败";
        }
            
            break;
        case 4: // 少参数
            msg = @"少参数";
            break;
        case 5: // 无效参数
            msg = @"无效参数";
            break;
        case 6: // 数据格式错误
            msg = @"数据格式错误";
            break;
        case 7: // api 访问次数达上限
            msg = @"api 访问次数达上限";
            break;
        case 8: // 请求已过期
            msg = @"请求已过期";
            break;
        case 902:
            msg = @"邮箱已经存在";
            break;
        case 903:
            msg = @"服务器错误，请稍后重试";
            break;
        default:
            msg = @"服务器错误，请稍后重试";
            break;
    }
    
    
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response {
    return;
}



@end
