//
//  Services.h
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#ifndef Journey_Services_h
#define Journey_Services_h

#define SECURITY_CODE       @"ihakula.ifinancial.scode"
#define NH_CODE             @"ihakula_northern_hemisphere"
#define APP_KEY             @"BBQ2015"

#define IH_PRODUCTION       1

#if IH_PRODUCTION == 1
#define HOST_NAME           @"112.124.41.173"
#define SERVICE_ROOT_URL    @"http://112.124.41.173:8090/"
#else
#define HOST_NAME           @"127.0.0.1"
#define SERVICE_ROOT_URL    @"http://127.0.0.1:8090/"
#endif

/////////////////////////// Services ///////////////////////////////////////////

#define BBQ_WEB_IMAGE_URL(imageName)                [NSString stringWithFormat:@"%@image/%@?ihakula_request=%@", SERVICE_ROOT_URL, imageName, NH_CODE]


#define SERVICE_GET_ALL_GOODS                       @"goods"
#define SERVICE_PUSH_NOTIFICATION                   @"push_notification"

#define SERVICE_PUT_ORDER                           @"insert/order"
#define SERVICE_GET_IN_PROGRESS_ORDERS              @"in/progress/orders"
#define SERVICE_GET_FINISHED_ORDERS                 @"finished/orders"
#define SERVICE_CANCEL_ORDER                        @"cancel/order"
#define SERVICE_ACCEPT_ORDER                        @"order/accepted"
#define SERVICE_DELIVERY_ORDER                      @"order/delivery"
#define SERVICE_PAID_ORDER                          @"order/paid"
#define SERVICE_FINISHED_ORDER                      @"order/finished"
#define SERVICE_GET_ORDER_DETAIL                    @"order/detail"

#define SERVICE_UPLOAD_CONTACT                      @"user/upload/contact"
#define SERVICE_GET_CONTACT                         @"user/get/contact"

#define SERVICE_FEEDBACK                            @"feedback"
#define SERVICE_REGISTER                            @"register"
#define SERVICE_LOGIN                               @"login"
#define SERVICE_LOGOUT                              @"logout"
#define SERVICE_GET_FUNDS                           @"getpurchasedfunds"
#define SERVICE_UPLOAD_TOKEN                        @"uploadtoken"
#define SERVICE_UPDATE_SESSION                      @"whoami"
#define SERVICE_GET_ALL_FUNDS                       @"getallfunds"
#define SERVICE_UPDATE_PURCHASED_UNIT               @"uploadtrade"
#define SERVICE_GET_PROUD                           @"getproud"
#define SERVICE_GET_HIS_INCOME                      @"gethisincome"
#define SERVICE_GET_CONFIRM_DEPOSIT                 @"getconfirmdeposit"
#define SERVICE_UPDATE_AMOUNT                       @"updateamount"
#define SERVICE_GET_ANNUAL_RATE                     @"getannualrate"
#define SERVICE_GET_FIELDS                          @"getFields"
#define SERVICE_ADD_RECORD                          @"addRecord"
#define SERVICE_GET_ANALYSEYEARS                    @"getAnalyseYears"
#define SERVICE_GET_ANALYSES                        @"getAnalyse"

#define SERVICE_GET_GROUP_ACCOUNTS                  @"getGroupRecords"

#endif
