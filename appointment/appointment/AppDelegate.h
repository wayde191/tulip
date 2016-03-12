//
//  AppDelegate.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/9/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    CLLocationManager *_locateManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) SSInterfaceOrientationMask interfaceOrientationMask;

- (void)hideTodoView;
- (void)showMsg:(NSString *)message;

- (void)setupMenu:(NSArray *)menuArr;
- (void)showMenu;
- (void)hideMenu;

- (void)showAdView;
- (void)showAds:(NSDictionary *)ad;
- (void)hideAdView;

- (void)clearNotification;
+ (AppDelegate *)getSharedAppDelegate;

@end

