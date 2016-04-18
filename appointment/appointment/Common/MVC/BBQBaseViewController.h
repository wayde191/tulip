//
//  JBaseViewController.h
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHBaseViewController.h"
#import "AppDelegate.h"
#import "KeyboardView.h"
#import "NetworkIssueView.h"
#import "MobClick.h"

@interface BBQBaseViewController : iHBaseViewController <UIActionSheetDelegate> {
    AppDelegate *appDelegate;
    NetworkIssueView *networkIssueView;
}

// KeyboardView
@property (assign, nonatomic) BOOL showingKeyboardAssistantView;
@property (strong, nonatomic) KeyboardView *keyboardAssistantView;
- (void)setupKeyboardView;

// NetworkIssueView
- (void)showNetworkIssueView;
- (void)removeNetworkIssueView;

// Navigation bar items
- (void)setupRightSaveItem;
- (void)addLeftBackItem:(SEL)action;
- (void)leftBackBtnClicked;
- (void)setNavBarDefaultStyle;
- (void)setNavBarDefaultImage;
- (void)setupNavigationItems;

// Status bar
- (void)setStatusBarColor:(UIColor *)customerColor;
- (void)restoreBarToDefaultStyle;

// Notification
- (void)iHMsgReceivedWithSender:(NSNotification *)sender;
- (BOOL)getNotificationReceivedNotLoggedIn;

- (void)showAlertMessage:(NSString *)msg;
- (void)showAlertMessage:(NSString *)msg withTitle:(NSString *)title;
- (void)showMessage:(NSString *)msg;
- (void)showWarningMessage:(NSString *)msg;
- (void)showDoneMessage:(NSString *)msg;
- (void)showLoadingMessage:(NSString *)msg;
- (void)showErrorMessage:(NSString *)msg;
- (void)showTestMessage;
- (void)showStaticMessage:(NSString *)msg;
- (void)hideMessage;
- (void)showNetworkIssue;
- (void)showNetworkRecory:(NSString *)type;

- (void)showNoResults;

- (void)gotoLoginViewController;
- (void)gotoAddressViewController;

- (void)adjustElementsConstrantHeight;
- (void)adjustConstrantsHeightByType:(NSString *)type withViews:(NSArray *)views;

// Timetamp
- (NSString *)getPicWebAddress:(NSString *)address;

- (void)cancelAllRequest;
@end
