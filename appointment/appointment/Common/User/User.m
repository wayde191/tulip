//
//  User.m
//  iFinancial
//
//  Created by Wayde Sun on 3/5/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "iHValidationKit.h"
#import "APService.h"

#define IF_CACHED_DATA          @"IFinancialCachedData"
#define IF_REFRESHED_DAY        @"IFinancialRefreshedDay"
#define IF_USER_ID              @"IFinancialUserId"
#define IF_GROUP_ID             @"IFinancialGroupId"
#define IF_USER_EMAIL           @"IFinancialUserEmail"
#define IF_USER_NAME            @"IFinancialUserName"
#define IF_USER_FUNDS           @"IFinancialUserFunds"
#define IF_OBSERVED_FUNDS       @"IFinancialObservedFunds"
#define IF_ALL_FUNDS            @"IFinancialAllFunds"

#define GET_MENU_SERVICE            @"GetMenuService"
#define GET_AD_SERVICE              @"GetAdService"

#define UPDATE_SESSION_SERVICE      @"UpdateSessionService"
#define GET_ALL_FUNDS_SERVICE       @"GetAllFundsService"
#define UPLOAD_TOKEN_SERVICE        @"UploadTokenService"

#define GET_USER_CONTACT_SERVICE    @"GetUserContactService"

//Singleton model
static User *singletonInstance = nil;

@interface User (){
    AppDelegate *_appDelegate;
    
    NSMutableDictionary *_cachedData;
    iHNetworkMonitor *_monitor;
    
    NSDateComponents *_refreshedDayComponents;
    NSString *_userId;
    NSString *_groupId;
    NSString *_userEmail;
    NSString *_userName;
    
    
    void(^ _getAllFundsWhenDone)(void) ;
}

- (void)restoreCachedData;
- (void)initCachedData;

@end

@implementation User

- (id)init
{
    self = [super init];
    if (self) {
        _appDelegate = [AppDelegate getSharedAppDelegate];
        [self initRequest];
        
        _monitor = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
        _monitor.hostUrl = HOST_NAME;
        [_monitor startNotifer];
        
        [self setupUserData];

    }
    return self;
}

- (void)initRequest {
    iHRequest *request = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHRequest"];
    
    //Default options
    [request setupDefaultOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  SERVICE_ROOT_URL, @"serviceRoot",
                                  nil]];
    [request setupExtraHeaders:@{@"Authorization": @"1:1:abc"}];
//    [request setupCommonOptions:[NSDictionary dictionaryWithObjectsAndKeys:
//                                 NH_CODE, @"ihakula_request",
//                                 nil]];
}

#pragma mark - Public Methods
- (void)doUploadToken {
//    theRequest.requestMethod = iHRequestMethodPost;
    NSString *token = [USER_DEFAULT objectForKey:IH_DEVICE_TOKEN];
    if (token) {
        NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"iFinanical", @"app",
                               @"1.0.0", @"version",
                               CURRENT_LANGUAGE, @"language",
                               [UIDevice currentDevice].systemName, @"platform",
                               [UIDevice currentDevice].systemVersion, @"os",
                               [UIDevice currentDevice].localizedModel, @"device",
                               token, @"token",
                               _userId, @"userId",
                               nil];
        
        [self doCallService:UPLOAD_TOKEN_SERVICE withParameters:paras andServiceUrl:SERVICE_UPLOAD_TOKEN forDelegate:nil];
    }
}

- (void)loginSuccess:(NSDictionary *)uinfo
{
    _userEmail = [uinfo objectForKey:@"email"];
    _userName = [uinfo objectForKey:@"name"];
    _userId = [uinfo objectForKey:@"id"];
    _groupId = [uinfo objectForKey:@"group_id"];
    
    [_cachedData setObject:_userEmail forKey:IF_USER_EMAIL];
    [_cachedData setObject:_userName forKey:IF_USER_NAME];
    [_cachedData setObject:_userId forKey:IF_USER_ID];
    [_cachedData setObject:_groupId forKey:IF_GROUP_ID];
    
    [self syncCachedData];
    
    [APService setAlias:_userEmail
       callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                 object:self];
    
    
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    iHDINFO(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
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

- (void)restoreUser
{
    //Unregister alias
    [APService setAlias:@""
       callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                 object:self];
    
    _userId = Nil;
    _userEmail = Nil;
    _userName = Nil;
    _refreshedDayComponents = Nil;
    
    [self restoreCachedData];
    [self syncCachedData];
}

- (NSString *)getUserId
{
    return _userId;
}

- (NSString *)getGroupId {
    return _groupId;
}

- (NSString *)getUserName
{
    return _userName;
}

- (NSString *)getUserEmail
{
    return _userEmail;
}

- (BOOL)isUserLoggedIn
{
    return [iHValidationKit isValueEmpty:_userId] ? NO : YES;
}

- (BOOL)isUserRefreshedDataToday
{
    if(!_refreshedDayComponents) {
        return NO;
    }
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    iHDINFO(@"\n --- %@ \n ----%@", today, _refreshedDayComponents);
    if([today day] == [_refreshedDayComponents day] &&
       [today month] == [_refreshedDayComponents month] &&
       [today year] == [_refreshedDayComponents year] ){
        return YES;
    }
    
    return NO;
}

- (NSString *)getAppKey {
    return @"key";
}

- (void)updateRefreshedDay
{
    _refreshedDayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    [_cachedData setObject:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] forKey:IF_REFRESHED_DAY];
}

- (void)syncCachedData
{
    iHDINFO(@"sync ---- %@", _cachedData);
    [USER_DEFAULT setObject:_cachedData forKey:IF_CACHED_DATA];
    [USER_DEFAULT synchronize];
}

#pragma mark - Class Methods
+ (User *)sharedInstance
{
    //The @synchronized()directive locks a section of code for use by a single thread
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[User alloc] init];
        }
        
        return singletonInstance;
    }
    
    return nil;
}

#pragma mark - Private Methods
- (void)setupUserData {
    [self doCallGetMenuService];
    [self doCallGetAdService];
}

- (void)doCallGetMenuService {
    theRequest.requestMethod = iHRequestMethodGet;
    [self doCallHttpService:GET_MENU_SERVICE withParameters:nil andServiceUrl:SERVICE_GET_MENU forDelegate:self];
}

- (void)doCallGetAdService {
    theRequest.requestMethod = iHRequestMethodGet;
    [self doCallHttpService:GET_AD_SERVICE withParameters:nil andServiceUrl:SERVICE_GET_WELCOME_AD forDelegate:self];
//    [self doCallHttpService:GET_AD_SERVICE withParameters:nil andServiceUrl:SERVICE_GET_WELCOME_NO_AD forDelegate:self];
}

- (void)initCachedData
{
    _cachedData = [[USER_DEFAULT objectForKey:IF_CACHED_DATA] mutableCopy];
    
    _refreshedDayComponents = nil;
    NSString *day = [_cachedData objectForKey:IF_REFRESHED_DAY];
    if (![iHValidationKit isValueEmpty:day]) {
        _refreshedDayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithString:[_cachedData objectForKey:IF_REFRESHED_DAY] formate:@"yyyy-MM-dd"]];
    }
    
    _userId = [_cachedData objectForKey:IF_USER_ID];
    _groupId = [_cachedData objectForKey:IF_GROUP_ID];
    _userEmail = [_cachedData objectForKey:IF_USER_EMAIL];
    _userName = [_cachedData objectForKey:IF_USER_NAME];
}

- (void)restoreCachedData
{
    _cachedData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   @"", IF_REFRESHED_DAY,
                   @"", IF_USER_ID,
                   @"", IF_GROUP_ID,
                   @"", IF_USER_NAME,
                   @"", IF_USER_EMAIL,
                   @"", IF_USER_FUNDS,
                   @"", IF_OBSERVED_FUNDS,
                   @"", IF_ALL_FUNDS,
                   nil];
    _userId = nil;
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:GET_MENU_SERVICE]) {
        iHDINFO(@"%@", response.userInfoDic);
        self.dynamicMenuArr = response.userInfoDic[@"data"];
        
    } else if ([response.serviceName isEqualToString:GET_AD_SERVICE]) {
        self.adDic = response.userInfoDic[@"data"];
        [_appDelegate showAds:_adDic];
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:GET_MENU_SERVICE]) {
        
    } else if ([response.serviceName isEqualToString:GET_AD_SERVICE]) {
        [_appDelegate showAds:@{}];
    }
}


@end
