//
//  AppConfig.h
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#ifndef Journey_AppConfig_h
#define Journey_AppConfig_h

#import "Services.h"
#import "Fonts.h"

/////////////////////////// Global Status /////////////////////////////////////
typedef enum {
    kNHOrderStateInsert = 1,
    kNHOrderStateConfirmed,
    kNHOrderStateDelivery,
    kNHOrderStatePaied,
    kNHOrderStateDone,
    kNHOrderStateCancel,
    kNHOrderStateDeleted
}kNHOrderState;


/////////////////////////// Global Keys /////////////////////////////////////
#define USER_DEFAULT_GOODS_KEY           @"BBQUserDefaultHerosKey"
#define USER_DEFAULT_GOODS_DATE          @"BBQUserDefaultHerosDate"

#define NH_REMOTE_NOTIFICATION_RECEIVED                 @"NHRemoteNotificationReceived"
#define NOTIFICATION_CAR_ADDED                          @"NotificationCarAdded"
#define NOTIFICATION_CAR_UPDATED                        @"NotificationCarUpdated"
#define NOTIFICATION_REFRESH_ORDER_LIST                 @"NotificationRefreshOrderList"

#define TESTING_SWITCH_ON                   0

#define MK_PAGE_SIZE                        3
#define MK_PAGE_MAX_SIZE                    10000

#define NORMAL_KEYBOARD_SIZE_HEIGHT         280.0
#define OLD_IPHONE_SCROLL_INIT_TOP          -64.0
#define TAG_SPACE_WIDTH                     14

#define FAQ_DEFAULT_URL                     @"http://www.wkzuche.com:8080/zuche/download/FAQ.html"
#define REGISTER_TERM_DEFAULT_URL           @"http://www.wkzuche.com:8080/zuche/download/RegisterTerm.html"
#define SERVICE_TERM_DEFAULT_URL            @"http://www.wkzuche.com:8080/zuche/download/ServiceTerm.html"
#define PAY_TERM_DEFAULT_URL                @"http://www.wkzuche.com:8080/zuche/download/PayTerm.html"

#define YD_TEXTFIELD_TYPE                   @"YDTextField"
#define YD_BUTTON_TYPE                      @"YDButton"

#define IH_DEVICE_TOKEN                     @"iHDeviceTokenDota"
#define MK_FIRST_TIME_OPEN                  @"MKFirstTimeOpen"

#define LP_USERNAME                         @"LocatePeopleUsername"
#define LP_PASSWORD                         @"LocatePeoplePassword"
#define LP_REMEMBER                         @"LocatePeopleRemember"
#define LP_AUTO_LOGIN                       @"LocatePeopleAutoLogin"
#define MK_USER_AUTOLOGIN_INFO              @"MKUserAutologinInfo"


////////////////////////////////////////////////////////////
#define ANIMATION_DURATION                  0.3f

#define NOTIFICATION_GOODS_CHANGES          @"NotificationFoodsChanges"

#define BBQ_GOODS_KEY                       @"foods"
#define BBQ_GOODS_COUNTER_KEY               @"counter"

#define TABBAR_HEIGHT                       52.0f

#endif
