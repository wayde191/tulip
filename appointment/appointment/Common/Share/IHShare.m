//
//  IHShare.m
//  BBQ
//
//  Created by Wei Wayde Sun on 8/14/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#import "IHShare.h"
#import "BBQ+ShareSDK.h"

#define D_TITLE                             @"郁金香挂号"
#define D_CONTENT                           @"郁金香挂号 内容"
#define D_SITE_URL                          @"http://www.baidu.com"

#define D_QQSPACE_TITTLE                    @"郁金香挂号"
#define D_QQ_TITTLE                         @"郁金香挂号"
#define D_WX_SESSION_TITLE                  @"郁金香挂号"

#define D_PLATFORM                          @"郁金香挂号"

@interface IHShare (){
    id<ISSContent> _publishContent;
    id<ISSContainer> _container;
    id<ISSAuthOptions> _authOptions;
    id<ISSShareActionSheetItem> _sinaItem;
    id<ISSShareActionSheetItem> _qzoneItem;
    
    NSArray *_shareList;
}

@end

@implementation IHShare

- (id)init {
    self = [super init];
    if (self) {
        _authOptions = nil;
        self.sender = nil;
        self.title = D_TITLE;
        self.content = D_CONTENT;
        self.siteUrl = D_SITE_URL;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image triggerView:(id)sender {
    self = [self init];
    if (self) {
        self.image = image;
        self.sender = sender;
        [self build];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image triggerView:(id)sender title:(NSString *)title content:(NSString *)content url:(NSString *)url {
    self = [self init];
    if (self) {
        self.image = image;
        self.sender = sender;
        self.title = title;
        self.content = content;
        self.siteUrl = url;
        [self build];
    }
    return self;
}

- (void)showShareActionSheet {
    [ShareSDK showShareActionSheet:_container
                         shareList:_shareList
                           content:_publishContent
                     statusBarTips:YES
                       authOptions:_authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:self.shareDelegate
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess) {
                                    if (self.shareSuccessHandler) {
                                        self.shareSuccessHandler();
                                    }
                                } else if (state == SSPublishContentStateFail) {
                                    if (self.sharefailsHandler) {
                                        self.sharefailsHandler();
                                    }
                                }
                            }];
}


#pragma mark - Private Methods
- (void)build {
    [self initContent];
    [self setupContainer];
    [self customizeSinaActionSheetItem];
    [self customizeQZoneActionSheetItem];
    [self customizeWeixinSessionContent];
    [self customizeWeixinTimelineContent];
    [self initShareList];
}

- (id<ISSCAttachment>)getImage {
    NSData *data = UIImageJPEGRepresentation(self.image, 0.8);
    return [ShareSDK imageWithData:data fileName:@"tulip" mimeType:@"jpeg"];
}

- (void)initContent {
    _publishContent = [ShareSDK content:self.content
                         defaultContent:@""
                                  image: [self getImage]
                                  title:self.title
                                    url:self.siteUrl
                            description:self.desc
                              mediaType:SSPublishContentMediaTypeNews];
}

- (void)customizeQQSpaceContent {
    [_publishContent addQQSpaceUnitWithTitle:D_QQSPACE_TITTLE
                                         url:INHERIT_VALUE
                                        site:nil
                                     fromUrl:nil
                                     comment:INHERIT_VALUE
                                     summary:INHERIT_VALUE
                                       image:INHERIT_VALUE
                                        type:INHERIT_VALUE
                                     playUrl:nil
                                        nswb:nil];
    
}

- (void)customizeQQContent {
    [_publishContent addQQUnitWithType:INHERIT_VALUE
                               content:INHERIT_VALUE
                                 title:D_QQ_TITTLE
                                   url:INHERIT_VALUE
                                 image:INHERIT_VALUE];
}

- (void)customizeWeixinSessionContent {
    [_publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                          content:self.content
                                            title:self.title
                                              url:self.siteUrl
                                       thumbImage:[self getImage]
                                            image:[self getImage]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
}

- (void)customizeWeixinTimelineContent {
    [_publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                           content:self.content
                                             title:self.title
                                               url:self.siteUrl
                                        thumbImage:[self getImage]
                                             image:INHERIT_VALUE
                                      musicFileUrl:nil
                                           extInfo:nil
                                          fileData:nil
                                      emoticonData:nil];
}

- (void)setupContainer {
    _container = [ShareSDK container];
    [_container setIPadContainerWithView:self.sender arrowDirect:UIPopoverArrowDirectionUp];
}

- (void)addAuth {
    _authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                       allowCallback:YES
                                       authViewStyle:SSAuthViewStyleFullScreenPopup
                                        viewDelegate:nil
                             authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [_authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [ShareSDK userFieldWithType:SSUserFieldTypeName value:D_PLATFORM],
                                     SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                     [ShareSDK userFieldWithType:SSUserFieldTypeName value:D_PLATFORM],
                                     SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                     nil]];
}

- (void)customizeSinaActionSheetItem {
    _sinaItem = [ShareSDK
                 shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                 icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                 clickHandler:^{
                     [ShareSDK shareContent:_publishContent
                                       type:ShareTypeSinaWeibo
                                authOptions:_authOptions
                              statusBarTips:YES
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                         
                                         if (state == SSPublishContentStateSuccess) {
                                             if (self.shareSuccessHandler) {
                                                 self.shareSuccessHandler();
                                             }
                                         } else if (state == SSPublishContentStateFail) {
                                             if (self.sharefailsHandler) {
                                                 self.sharefailsHandler();
                                             }
                                         }
                                     }];
                 }];
}

- (void)customizeQZoneActionSheetItem {
    _qzoneItem = [ShareSDK
                  shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                  icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                  clickHandler:^{
                      [ShareSDK shareContent:_publishContent
                                        type:ShareTypeQQSpace
                                 authOptions:_authOptions
                               statusBarTips:YES
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          
                                          if (state == SSPublishContentStateSuccess) {
                                              if (self.shareSuccessHandler) {
                                                  self.shareSuccessHandler();
                                              }
                                          } else if (state == SSPublishContentStateFail) {
                                              if (self.sharefailsHandler) {
                                                  self.sharefailsHandler();
                                              }
                                          }
                                      }];
                  }];
}

- (void)initShareList {
    _shareList = [ShareSDK customShareListWithType:
                  SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                  SHARE_TYPE_NUMBER(ShareTypeQQ),
                  SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                  SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                  SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                  nil];
}

#pragma mark - Class Methods
+ (BOOL)isPreferredChinese {
    BOOL result = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [allLanguages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hans"]) {
        result = YES;
    }
    
    return result;
}

@end
