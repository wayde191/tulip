//
//  IHShare.h
//  BBQ
//
//  Created by Wei Wayde Sun on 8/14/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface IHShare : NSObject

typedef void (^ShareSuccessHandler)();
typedef void (^ShareFailsHandler)();
@property (copy, nonatomic) ShareSuccessHandler shareSuccessHandler;
@property (copy, nonatomic) ShareFailsHandler sharefailsHandler;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id sender;
@property (nonatomic, weak) id shareDelegate;

- (id)initWithImage:(UIImage *)image triggerView:(id)sender;
- (id)initWithImage:(UIImage *)image triggerView:(id)sender title:(NSString *)title content:(NSString *)content url:(NSString *)url;
- (void)showShareActionSheet;

+ (BOOL)isPreferredChinese;

@end
