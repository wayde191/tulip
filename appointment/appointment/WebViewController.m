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

#define SEPARATED_SIGNAL @"00110011"
#define TULIP_PROTOCOL   @"tulip"

#define FIRST_SCREEN_HEIGHT             300

@interface WebViewController (){
    NSString *_leftUrl;
    NSString *_leftScriptStr;
    NSString *_rightUrl;
    NSString *_rightScriptStr;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _trustedHosts = [[NSMutableArray alloc] init];
    
    self.title = @"就诊城市";
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma --WebViewDelegate--
- (void)setAgent {
    // Add for icbc bank of China
    NSDictionary *useragentDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0_2 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A400 Safari/6531.22.7", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:useragentDic];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self setAgent];
    
    if ([[[request URL] scheme] isEqualToString:TULIP_PROTOCOL]) {
        NSString *url = [NSString stringWithFormat:@"%@", [request URL]];
        NSString *infoStr = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:", TULIP_PROTOCOL] withString:@""];
        NSArray *infoArr = [infoStr componentsSeparatedByString:SEPARATED_SIGNAL];
        [self dispatch:infoArr];
        
        return NO;
        
    } else if ([[[request URL] scheme] isEqualToString:@"https"]) {
        [self addTrustedHost:self.urlString];
    }
    
    self.urlString = [NSString stringWithFormat:@"%@", [request URL]];
//
//    // Goto load app page
//    NSArray *urlComps = [self.urlString componentsSeparatedByString:@"://"];//根据://标记将字符串分成数组
//    
//    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"itms-apps"]){
//        NSString* webStringURL = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: webStringURL]];
//    }
    
    iHDINFO(@"urlString %@", self.urlString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showMessage:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self hideMessage];
    
    NSString *absoluteString = [self.webview.request.URL absoluteString];
    iHDINFO(@"absoluteString %@", absoluteString);
    
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
        NSString *deviceScript = [NSString stringWithFormat:@"window.cb.deviceId(%@)",
                                  [[User sharedInstance] getUUID]];
        [self.webview stringByEvaluatingJavaScriptFromString:deviceScript];
        
    } else if ([action isEqualToString:@"getLocation"]) {
        NSString *locationScript = [NSString stringWithFormat:@"window.cb.location(%@, %@)",
                                    [[User sharedInstance] getLongitudeStr],
                                    [[User sharedInstance] getLatitudeStr]];
        [self.webview stringByEvaluatingJavaScriptFromString:locationScript];
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
    if (error == nil) {
        [self showDoneMessage:@"截图保存成功"];
    }else{
        [self showErrorMessage:@"截图保存失败"];
    }
}

- (UIImage *)getScreenshotImage {
    UIImage *newImg = nil;
    
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
    
    [self.webview.scrollView setContentOffset:CGPointMake(0, 0)];
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

@end
