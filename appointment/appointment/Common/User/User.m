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
    NSDictionary *_contactDic;
    NSArray *_allFunds;
    
    void(^ _getAllFundsWhenDone)(void) ;
}

- (void)restoreCachedData;
- (void)initCachedData;
- (void)setupAllFunds:(NSArray *)funds;

@end

@implementation User

- (id)init
{
    self = [super init];
    if (self) {
        _appDelegate = [AppDelegate getSharedAppDelegate];
        _cartFoodsNumber = 0;
        self.goodsDic = [@{} mutableCopy];
        _contactDic = @{};
        
        [self initRequest];
        
        _monitor = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
        _monitor.hostUrl = HOST_NAME;
        [_monitor startNotifer];

    }
    return self;
}

- (void)initRequest {
    iHRequest *request = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHRequest"];
    
    //Default options
    [request setupDefaultOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                  SERVICE_ROOT_URL, @"serviceRoot",
                                  nil]];
    
    [request setupCommonOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                 NH_CODE, @"ihakula_request",
                                 nil]];
}

#pragma mark - Public Methods
- (void)clearGoods {
    [self.goodsDic removeAllObjects];
    [self restoreGoodsNumber];
}

- (void)addFood {
    self.cartFoodsNumber++;
    [iHPubSub publishMsgWithSubject:NOTIFICATION_GOODS_CHANGES andDataDic:@{}];
}

- (void)reduceFood {
    self.cartFoodsNumber--;
    [iHPubSub publishMsgWithSubject:NOTIFICATION_GOODS_CHANGES andDataDic:@{}];
}

- (NSDictionary *)getTotalPrice {
    CGFloat price = 0.0;
    CGFloat realPrice = 0.0;
    NSInteger goodsNumber = 0;
    
    NSArray *keys = [_goodsDic allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSDictionary *goodsBase = _goodsDic[keys[i]];
        NSNumber *counter = goodsBase[BBQ_GOODS_COUNTER_KEY];
        NSDictionary *goods = goodsBase[BBQ_GOODS_KEY];
        NSNumber *discountPrice = goods[@"member_price"];
        NSNumber *fullPrice = goods[@"sale_price"];
        
        price += (discountPrice.floatValue * counter.integerValue);
        realPrice += (fullPrice.floatValue * counter.integerValue);
        goodsNumber += counter.integerValue;
    }
    
    return @{@"counter":[NSNumber numberWithInteger:goodsNumber],
             @"price":[NSNumber numberWithFloat:price],
             @"realPrice":[NSNumber numberWithFloat:realPrice]};
}

- (void)addFoodsDic:(NSDictionary *)foods {
    NSString *foodsIdStr = [foods[@"ID"] stringValue];
    NSDictionary *foodsBaseDic = self.goodsDic[foodsIdStr];
    if (foodsBaseDic) {
        NSInteger counter = [foodsBaseDic[@"counter"] integerValue];
        self.goodsDic[foodsIdStr] = @{
                                      BBQ_GOODS_KEY:foods,
                                      BBQ_GOODS_COUNTER_KEY: [NSNumber numberWithInteger:counter + 1]
                                      };
        
    } else {
        self.goodsDic[foodsIdStr] = @{
                                      BBQ_GOODS_KEY:foods,
                                      BBQ_GOODS_COUNTER_KEY: [NSNumber numberWithInteger:1]
                                      };
    }
}

- (void)reduceFoodsDic:(NSDictionary *)foods {
    NSString *foodsIdStr = [foods[@"ID"] stringValue];
    NSDictionary *foodsBaseDic = self.goodsDic[foodsIdStr];
    if (foodsBaseDic) {
        NSInteger counter = [foodsBaseDic[@"counter"] integerValue];
        if (counter == 1) {
            [self.goodsDic removeObjectForKey:foodsIdStr];
        } else {
            self.goodsDic[foodsIdStr] = @{
                                      BBQ_GOODS_KEY:foods,
                                      BBQ_GOODS_COUNTER_KEY: [NSNumber numberWithInteger:counter - 1]
                                      };
        }
        
    } else {
        self.goodsDic[foodsIdStr] = @{
                                      BBQ_GOODS_KEY:foods,
                                      BBQ_GOODS_COUNTER_KEY: [NSNumber numberWithInteger:1]
                                      };
    }
}

- (void)doUploadToken {
    theRequest.requestMethod = iHRequestMethodPost;
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

- (float)getMyTotalAssests
{
    float assests = 00.00;
    
    return assests;
}

- (BOOL)amiManager {
    return [_groupId isEqualToString:@"99"];
}

- (void)updateUserContact:(NSDictionary *)contact {
    _contactDic = contact;
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
    [self doCallGetContactService];
    
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

- (NSDictionary *)getContact {
    return _contactDic;
}

- (BOOL)isUserLoggedIn
{
    return [iHValidationKit isValueEmpty:_userId] ? NO : YES;
}

- (void)refreshAllFundsOnceADay:(void (^)(void))whenDone
{
    _getAllFundsWhenDone = whenDone;
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_ALL_FUNDS_SERVICE  withParameters:nil andServiceUrl:SERVICE_GET_ALL_FUNDS forDelegate:self];
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

- (void)doCallGetContactService {
    NSDictionary *parass = [NSDictionary dictionaryWithObjectsAndKeys:
                            _userId, @"user_id",
                            nil];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:GET_USER_CONTACT_SERVICE withParameters:parass andServiceUrl:SERVICE_GET_CONTACT forDelegate:self];
}

- (void)doCallLoginService {
    NSDictionary *parass = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"wsun191@gmail.com", @"ihakulaID",
                           @"wayde191", @"password",
                           @"ihakula.ifinancial.scode", @"sCode",
                           nil];
    
    theRequest.requestMethod = iHRequestMethodPost;
    [self doCallService:@"LOGIN_SERVICE" withParameters:parass andServiceUrl:SERVICE_LOGIN forDelegate:self];
}

- (void)doUpdateTokenSessionOnceADay
{
    theRequest.requestMethod = iHRequestMethodPost;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"session",
                          @"", @"userid",
                          nil];
    [self doCallService:UPDATE_SESSION_SERVICE  withParameters:para andServiceUrl:SERVICE_UPDATE_SESSION forDelegate:self];
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
    
    _allFunds = [NSArray array];
    NSArray *funds = [_cachedData objectForKey:IF_ALL_FUNDS];
    if (![iHValidationKit isValueEmpty:funds]) {
        [self setupAllFunds:[_cachedData objectForKey:IF_ALL_FUNDS]];
    }
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

- (void)setupAllFunds:(NSArray *)funds
{
}

- (NSArray *)getAllFunds
{
    return _allFunds;
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    [super serviceCallSuccess:response];
    if ([response.serviceName isEqualToString:@"LOGIN_SERVICE]"]) {
        iHDINFO(@"%@", response.userInfoDic);
    } else if ([response.serviceName isEqualToString:GET_USER_CONTACT_SERVICE]) {
        NSArray *contactArr = response.userInfoDic[@"contact"];
        _contactDic = contactArr.count > 0 ? contactArr[0] : @{};
    }
}

- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    [super serviceCallFailed:response];
    if ([response.serviceName isEqualToString:@"LOGIN_SERVICE]"]) {
        iHDINFO(@"%@", response.userInfoDic);
    }
}

- (void)restoreGoodsNumber {
    self.cartFoodsNumber = 0;
}


@end
