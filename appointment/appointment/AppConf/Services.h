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
#define HOST_NAME           @"sandbox.api.sibosen.com"
#define SERVICE_ROOT_URL    @"http://sandbox.api.sibosen.com/"
#else
#define HOST_NAME           @"127.0.0.1"
#define SERVICE_ROOT_URL    @"http://127.0.0.1:8090/"
#endif

/////////////////////////// Services ///////////////////////////////////////////

#define BBQ_WEB_IMAGE_URL(imageName)                [NSString stringWithFormat:@"%@image/%@?ihakula_request=%@", SERVICE_ROOT_URL, imageName, NH_CODE]


#define SERVICE_GET_MENU                            @"v2/settings/menu"
#define SERVICE_GET_WELCOME_NO_AD                   @"v2/settings/ad1"
#define SERVICE_GET_WELCOME_AD                      @"v2/settings/ad2"

#define SERVICE_LOGIN                               @"login"
#define SERVICE_UPLOAD_TOKEN                        @"upload_token"

#endif
