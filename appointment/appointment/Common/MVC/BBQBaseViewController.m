//
//  JBaseViewController.m
//  Journey
//
//  Created by Wayde Sun on 6/30/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "BBQBaseViewController.h"
#import "iHArithmeticKit.h"
#import "FVCustomAlertView.h"

#define TEXTFIELD_CONSTRANT_HEIGHT      55
#define BUTTON_CONSTRANT_HEIGHT         55

@interface BBQBaseViewController () {
    UIView *_customerStatubar;
    
    BOOL _notificationReceivedNotLoggedIn;
    NSDictionary *_notificationReveivedUserInfoDic;
}
- (void)callBtnClicked;
@end

@implementation BBQBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate = [AppDelegate getSharedAppDelegate];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        appDelegate = [AppDelegate getSharedAppDelegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    appDelegate = [AppDelegate getSharedAppDelegate];
    
    [self setupNavigationItems];
}

- (BOOL)getNotificationReceivedNotLoggedIn {
    return _notificationReceivedNotLoggedIn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    [iHPubSub subscribeWithSubject:NH_REMOTE_NOTIFICATION_RECEIVED byInstance:self];
    
    if (_notificationReceivedNotLoggedIn) {
        [self gotoOrderDetailViewController:_notificationReveivedUserInfoDic];
        _notificationReceivedNotLoggedIn = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    [iHPubSub unsubscribeWithSubject:NH_REMOTE_NOTIFICATION_RECEIVED ofInstance:self];
    [self cancelAllRequest];
}

- (void)dealloc {
}

- (void)adjustElementsConstrantHeight {
    // children does
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (NSString *)getPicWebAddress:(NSString *)address {
    NSString *webaddress = [NSString stringWithFormat:@"%@?timestamp=%@", address, [iHArithmeticKit getCurrentTimetamp]];
    webaddress = [webaddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return webaddress;
}

- (void)adjustConstrantsHeightByType:(NSString *)type withViews:(NSArray *)views {
    NSString *visualFormat = nil;
    
    if ([type isEqualToString:YD_TEXTFIELD_TYPE]) {
        visualFormat = [NSString stringWithFormat:@"V:[viewName(==%d)]", TEXTFIELD_CONSTRANT_HEIGHT];
        
        for (UITextField *viewName in views) {
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(viewName);
            NSArray *constraints =
            [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                    options:0 metrics:nil views:viewsDictionary];
            [self.view addConstraints:constraints];
            viewName.font = [UIFont systemFontOfSize:20];
        }
        
    } else if ([type isEqualToString:YD_BUTTON_TYPE]) {
        visualFormat = [NSString stringWithFormat:@"V:[viewName(==%d)]", BUTTON_CONSTRANT_HEIGHT];
        
        for (UIButton *viewName in views) {
            NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(viewName);
            NSArray *constraints =
            [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                    options:0 metrics:nil views:viewsDictionary];
            [self.view addConstraints:constraints];
            viewName.titleLabel.font = [UIFont systemFontOfSize:22];
        }
    }
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showAlertMessage:(NSString *)msg withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showTestMessage {
    [FVCustomAlertView showAlertOnView:self.view withTitle:@"Test" titleColor:[UIColor greenColor] width:200 height:100 backgroundImage:nil backgroundColor:[UIColor greenColor] cornerRadius:10.0 shadowAlpha:0.5 alpha:1.0 contentView:nil type:FVAlertTypeWarning];
    [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"加载中..."];
}

- (void)showWarningMessage:(NSString *)msg {
    [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:msg];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2.0];
}

- (void)showDoneMessage:(NSString *)msg {
    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:msg];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2.0];
}

- (void)showLoadingMessage:(NSString *)msg {
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:msg];
}

- (void)showErrorMessage:(NSString *)msg {
    [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:msg];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2.0];
}

- (void)showMessage:(NSString *)msg {
    [FVCustomAlertView showDefaultIndicatorAlertOnView:self.view withTitle:msg];
}

- (void)showStaticMessage:(NSString *)msg{
    [FVCustomAlertView showDefaultIndicatorAlertOnView:self.view withTitle:msg];
}

- (void)hideMessage {
    [FVCustomAlertView hideAlertFromView:self.view fading:NO];
}

- (void)showNetworkIssue {
    [self hideMessage];
    [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"网络不可达"];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2.0];
}
- (void)showNetworkRecory:(NSString *)type {
    [self hideMessage];
    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:type];
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2.0];
}

- (void)showNoResults {
    UIAlertView *aalert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有数据" selectedBlock:^(NSInteger index) {
        [self.navigationController popViewControllerAnimated:YES];
    } cancelButtonTitle:nil otherButtonTitles:@"确认"];
    [aalert show];
}

- (void)gotoLoginViewController {
    UIStoryboard *sb = nil;
    sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    if (IS_IPAD) {
//        sb = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    } else {
//        sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    }
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LPLoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoAddressViewController {
    UIStoryboard *sb = nil;
    sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    if (IS_IPAD) {
//        sb = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//    } else {
//        sb = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    }
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AddressViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Statubar color
- (void)setStatusBarColor:(UIColor *)customerColor {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if (!_customerStatubar) {
            _customerStatubar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IH_DEVICE_WIDTH, 20)];
            [appDelegate.window.rootViewController.view addSubview:_customerStatubar];
        }
        _customerStatubar.backgroundColor = customerColor;
    }
}

- (void)restoreBarToDefaultStyle {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

#pragma mark - Navigationbar
- (IBAction)back
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
    else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

- (void)setupNavigationItems
{
    [self.navigationController.navigationBar setBackgroundColor:NAV_BAR_BG_NORMAL_COLOR];
    self.navigationController.navigationBar.tintColor = NAV_BAR_TITLE_NORMAL_COLOR;
    
    NSShadow *shadow = [[NSShadow alloc] init];    
    NSDictionary *dic = @{NSForegroundColorAttributeName:NAV_BAR_TITLE_NORMAL_COLOR,
                          NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                          NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = dic;
//
//    if (IOS7_OR_LATER) {
//        UIImage *navBg = [UIImage imageNamed:@"navbar_bg"];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageCompressForSize:navBg targetSize:CGSizeMake(IH_DEVICE_WIDTH, navBg.size.height)] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//        self.extendedLayoutIncludesOpaqueBars = FALSE;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = FALSE;
//        
//    } else {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
//    }
//    
//    if (self.navigationController.viewControllers.count > 1) {
//        [self leftItemImage:@"nav_left_btn" target:self action:@selector(back)];
//    }
}

- (void)setNavBarDefaultStyle {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)setNavBarDefaultImage {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)leftBackBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBackItem:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 29)];
    [btn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - Private Methods
- (void)setupRightSaveItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onRightSaveButtonClicked)];
}

- (void)onRightSaveButtonClicked {
}

- (void)callBtnClicked {
    // MKReverseGeocoder
    // CLGeocoder
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CallMeTitle")
                                                             delegate:self
                                                    cancelButtonTitle:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"Cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LOCALIZED_DEFAULT_SYSTEM_TABLE(@"ABiao"), LOCALIZED_DEFAULT_SYSTEM_TABLE(@"AHui"), nil];
    
    self.view.clipsToBounds = YES;
    [actionSheet showInView:appDelegate.window];
}

- (void)gotoOrderDetailViewController:(NSDictionary *)orderInfo {
    if (orderInfo) {
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        OrderDetail2ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"OrderDetail2ViewController"];
//        [(OrderDetail2ViewController *)vc setOrderDic:orderInfo];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cancelAllRequest {
    
}

#pragma mark - NetworkIssue View
- (void)showNetworkIssueView {
    if (!networkIssueView) {
        networkIssueView = [NetworkIssueView viewFromNib];
        networkIssueView.height = self.view.height;
        networkIssueView.width = self.view.width;
    }
    
    if (!networkIssueView.superview) {
        [self.view addSubview:networkIssueView];
    }
    
    [self.view bringSubviewToFront:networkIssueView];
}

- (void)removeNetworkIssueView {
    [networkIssueView removeFromSuperview];
}

#pragma mark - Keyboard view
- (void)setupKeyboardView {
    self.keyboardAssistantView = [KeyboardView viewFromNib];
    self.keyboardAssistantView.width = IH_DEVICE_WIDTH;
    self.keyboardAssistantView.top = 700;
    [self.view addSubview:self.keyboardAssistantView];
}

- (void)showKeyboardView {
    if (_showingKeyboardAssistantView && _keyboardAssistantView) {
        [self.view bringSubviewToFront:self.keyboardAssistantView];
        [UIView animateWithDuration:.3 animations:^{
            _keyboardAssistantView.top = IH_DEVICE_HEIGHT - keyboardSize.height - _keyboardAssistantView.height - self.navigationController.navigationBar.height - 20;
        }];
    }
}

-(void)keyboardWillShow: (NSNotification *)sender
{
    [super keyboardWillShow:sender];
    if (_keyboardAssistantView) {
        [super keyboardWillShow:sender];
        [self performSelector:@selector(showKeyboardView) withObject:nil afterDelay:.1];
    }
}

-(void)keyboardWillHide: (NSNotification *)sender
{
    [super keyboardWillHide:sender];
    if (_keyboardAssistantView) {
        [super keyboardWillHide:sender];
        [UIView animateWithDuration:.3 animations:^{
            _keyboardAssistantView.top = 700;
        }];
    }
}


#pragma mark - iHPubSub Message
- (void)iHMsgReceivedWithSender:(NSNotification *)sender
{
    NSDictionary *userDic = [sender userInfo];
    NSString *action = userDic[@"action"];
}
@end
