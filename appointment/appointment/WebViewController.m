//
//  WebViewController.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/11/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "WebViewController.h"
#import "IHShare.h"
#import "NavButton.h"
#import "NetworkIssueView.h"

#define SEPARATED_SIGNAL @"00110011"
#define TULIP_PROTOCOL   @"tulip"

#define FIRST_SCREEN_HEIGHT             300

@interface WebViewController (){
    NSString *_leftUrl;
    NSString *_leftScriptStr;
    NSString *_rightUrl;
    NSString *_rightScriptStr;
    
    BOOL _pageChanges;
}
@property (nonatomic, strong) NetworkIssueView *issueView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _trustedHosts = [[NSMutableArray alloc] init];
    
    self.title = @"就诊城市";
    [self setLeftGobackButton];
    
//    [self loadTestHtml];
    [self loadCurrentUrl];
    self.webview.scrollView.bounces = NO;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    [self setAgent];
    
    [self setupIssueView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma --WebViewDelegate--
- (void)setAgent {
    NSString* userAgent = [self.webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@ TULIP AGENT", userAgent];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] scheme] isEqualToString:TULIP_PROTOCOL]) {
        NSString *url = [NSString stringWithFormat:@"%@", [request URL]];
        iHDINFO(@"%@", url);
        NSString *infoStr = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:", TULIP_PROTOCOL] withString:@""];
        NSArray *infoArr = [infoStr componentsSeparatedByString:SEPARATED_SIGNAL];
        iHDINFO(@"%@", infoArr);
        [self dispatch:infoArr];
        
        return NO;
        
    } else if ([[[request URL] scheme] isEqualToString:@"https"]) {
        [self addTrustedHost:self.urlString];
    }
    
    self.urlString = [NSString stringWithFormat:@"%@", [request URL]];
    
    iHDINFO(@"urlString %@", self.urlString);
    return YES;
}

- (void)restoreNavByScheme {
    if ([[self.webview.request.URL scheme] isEqualToString:@"https"]
        || [[self.webview.request.URL scheme] isEqualToString:@"http"]) {
        iHDINFO(@"------restore");
        [self restoreNavigationButtons];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hideIssueView];
    [self showMessage:@"加载中..."];
    [self restoreNavByScheme];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self hideMessage];
    self.urlString = [self.webview.request.URL absoluteString];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showIssueView];
    
    iHDINFO(@"webview failed! Error %@ - %@ - %@", error, [error userInfo], [error localizedDescription]);
    [self hideMessage];
}

- (void)addTrustedHost:(NSString *)trustedHost {
    if (![_trustedHosts containsObject:trustedHost]) {
        [_trustedHosts addObject:trustedHost];
    }
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType {
    viewController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

#pragma mark - Dispatch HTML event
- (void)dispatch:(NSArray *)order {
    NSString *action = order[0];
    if ([action isEqualToString:@"leftActionButton"]) {
        [self setLeftButton:order];
        
    } else if ([action isEqualToString:@"rightActionButton"]) {
        [self setRightButton:order];
        
    } else if ([action isEqualToString:@"dataLoadingOpen"]) {
        [self hideMessage];
        [self showMessage:@"加载中..."];
        
    } else if ([action isEqualToString:@"dataLoadingClose"]) {
        [self hideMessage];
        
    } else if ([action isEqualToString:@"screenshot"]) {
        [self saveImageToAlbum];
        
    } else if ([action isEqualToString:@"socialSharing"]){
        [self showSharePage:order];
        
    } else if ([action isEqualToString:@"getDeviceId"]) {
        NSString *deviceScript = [NSString stringWithFormat:@"window.cb.deviceId('%@')",
                                  [[User sharedInstance] getUUID]];
        iHDINFO(@"%@", deviceScript);
        [self.webview stringByEvaluatingJavaScriptFromString:deviceScript];
        
    } else if ([action isEqualToString:@"getLocation"]) {
        NSString *locationScript = [NSString stringWithFormat:@"window.cb.location('%@', '%@')",
                                    [[User sharedInstance] getLongitudeStr],
                                    [[User sharedInstance] getLatitudeStr]];
        iHDINFO(@"%@", locationScript);
        [self.webview stringByEvaluatingJavaScriptFromString:locationScript];
        
    } else if ([action isEqualToString:@"backToHome"]) {
        [self setLeftGobackButton];
    }
}

- (void)setLeftButton:(NSArray *)order {
    NavButton *navButton = [NavButton viewFromNib];
    [navButton makeAsLeftNavigationButton];
    navButton.backLabel.text = [order[1] stringByRemovingPercentEncoding];
    if ([[order[2] substringToIndex:[@"javascript:" length]] isEqualToString:@"javascript:"]) {
        _leftUrl = nil;
        _leftScriptStr = order[2];
    } else {
        _leftUrl = order[2];
    }
    [navButton.button addTarget:self action:@selector(onLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
}

- (void)onLeftButtonClicked {
    if (_leftUrl) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_leftUrl]]];
    } else {
        [self.webview stringByEvaluatingJavaScriptFromString:_leftScriptStr];
    }
}

- (void)setRightButton:(NSArray *)order {
    NavButton *navButton = [NavButton viewFromNib];
    [navButton makeAsRightNavigationButton];
    navButton.nextLabel.text = [order[1] stringByRemovingPercentEncoding];
    if ([[order[2] substringToIndex:[@"javascript:" length]] isEqualToString:@"javascript:"]) {
        _rightUrl = nil;
        _rightScriptStr = order[2];
    } else {
        _rightUrl = order[2];
    }
    [navButton.button addTarget:self action:@selector(onRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
}

- (void)onRightButtonClicked {
    if (_rightUrl) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_rightUrl]]];
    } else {
        [self.webview stringByEvaluatingJavaScriptFromString:_rightScriptStr];
    }
}

- (void)showSharePage:(NSArray *)orderArr {
    NSString *title = [self getReadableString:orderArr[1]];
    NSString *content = [self getReadableString:orderArr[2]];
    NSString *imageUrl = orderArr[3];
    NSString *siteUrl = orderArr[4];
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:imgData];

    IHShare *shareGo = [[IHShare alloc] initWithImage:image triggerView:self.webview title:title content:content url:siteUrl];
    shareGo.shareDelegate = self;
    
    shareGo.shareSuccessHandler = ^(void){
        NSLog(@"Success");
        
    };
    shareGo.sharefailsHandler = ^(void){
        NSLog(@"Fails");
    };
    [shareGo showShareActionSheet];
}

- (NSString *)getReadableString:(NSString *)resource {
    return [resource stringByRemovingPercentEncoding];
}

- (void)saveImageToAlbum{
    UIImageWriteToSavedPhotosAlbum([self getScreenshotImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *screenScript = @"window.cb.screenshot";
    
    if (error == nil) {
        [self showDoneMessage:@"截图保存成功"];
        screenScript = [NSString stringWithFormat:@"%@('succ')", screenScript];
    }else{
        [self showErrorMessage:@"截图保存失败"];
        screenScript = [NSString stringWithFormat:@"%@('fail')", screenScript];
    }
    
    [self.webview stringByEvaluatingJavaScriptFromString:screenScript];
}

- (UIImage *)getScreenshotImage {
    UIImage *newImg = nil;
    CGFloat oldOffsetY = self.webview.scrollView.contentOffset.y;
    
    [self.webview.scrollView setContentOffset:CGPointMake(0, 0)];
    CGFloat posterHeight = self.webview.scrollView.contentSize.height + 30.0f;
    UIImage *img1 = [self takeScreenShotFromView:self.webview.scrollView withWidth:IH_DEVICE_WIDTH andHeight:FIRST_SCREEN_HEIGHT];
    [self.webview.scrollView setContentOffset:CGPointMake(0, FIRST_SCREEN_HEIGHT)];
    UIImage *img2 = [self takeScreenShotFromView:self.webview.scrollView withWidth:IH_DEVICE_WIDTH andHeight:posterHeight];
    
    UIGraphicsBeginImageContext(CGSizeMake(IH_DEVICE_WIDTH, posterHeight));
    [img2 drawInRect:CGRectMake(0, 0, IH_DEVICE_WIDTH, posterHeight)];
    [img1 drawInRect:CGRectMake(0, 0, IH_DEVICE_WIDTH, FIRST_SCREEN_HEIGHT)];
    newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.webview.scrollView setContentOffset:CGPointMake(0, oldOffsetY)];
    return newImg;
}

- (UIImage *)takeScreenShotFromView:(UIView *)scrollview
                          withWidth:(float)width
                          andHeight:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [scrollview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setLeftGobackButton {
    NavButton *navButton = [NavButton viewFromNib];
    [navButton makeAsLeftNavigationButton];
    navButton.backLabel.text = @"返回";
    [navButton.button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restoreNavigationButtons {
    [self setLeftGobackButton];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Private View
- (void)setupIssueView {
    self.issueView = [NetworkIssueView viewFromNib];
    _issueView.width = IH_DEVICE_WIDTH;
    _issueView.height = IH_DEVICE_HEIGHT;
    
    WebViewController __weak *weakself = self;
    _issueView.vchangedBlock = ^(NetworkIssueView *keyboard){
        [weakself hideIssueView];
        [weakself loadCurrentUrl];
    };
}

- (void)hideIssueView {
    [_issueView removeFromSuperview];
}

- (void)showIssueView {
    [self.view addSubview:_issueView];
}

- (void)loadCurrentUrl {
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

}

#pragma mark - Tests
- (void)loadTestHtml {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tests" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlStr baseURL:[NSURL URLWithString:filePath]];
}

@end
