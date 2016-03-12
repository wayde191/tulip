//
//  WebViewController.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/11/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "WebViewController.h"
#import "IHShare.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"就诊城市";
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onRightSaveButtonClicked:)];
}

- (void)onRightSaveButtonClicked:(id)sender {
    [self showSharePage:self.webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma --WebViewDelegate--
- (void)setAgent {
    // Add for icbc bank of China
    NSDictionary *useragentDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0_2 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A400 Safari/6531.22.7", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:useragentDic];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    [self setAgent];
//    self.urlString = [NSString stringWithFormat:@"%@", [request URL]];
//    if ([[[request URL] scheme] isEqualToString:@"https"]) {
//        [self addTrustedHost:self.urlString];
//    }
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
    [self showMessage:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self hideMessage];
    
//    NSString *absoluteString = [self.webView.request.URL absoluteString];
    //    NSString *documentElement = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement"];
    //    ITTDINFO(@"documentElement %@", documentElement);
    //    NSString *innerText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
    //    ITTDINFO(@"absoluteString %@", absoluteString);
    /*
     * detect /epayPage/epay? pay done url
     */
    
//    <a href="callback:whatever">Click me</a>
//    if ( [[[inRequest URL] scheme] isEqualToString:@"callback"] ) {
    
//    if (absoluteString)
//    {
//        NSRange foundRange = [absoluteString rangeOfString:@"/epayPage/epay?"];
//        if(foundRange.location != NSNotFound) {
//            [self doGetPayDoneOrderlist];
//        }
//    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    iHDINFO(@"webview failed! Error %@ - %@ - %@", error, [error userInfo], [error localizedDescription]);
    [self hideMessage];
}

- (void)addTrustedHost:(NSString *)trustedHost {
//    if (![_trustedHosts containsObject:trustedHost]) {
//        [_trustedHosts addObject:trustedHost];
//        
//        NSURL *payURL = [NSURL URLWithString:trustedHost];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:payURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
//        [request setHTTPMethod :@"POST" ];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        
//        //use choose to trust the certificate and send asynchronous request
//        NSURLConnection *theConncetion = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        if (theConncetion) {
//            theData = [[NSMutableData alloc] initWithData:nil];
//            ITTDINFO(@"ok");
//        }else{
//            ITTDINFO(@"error");
//        }
//        
//        while(!finished) {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
//        
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType {
    viewController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)showSharePage:(id)sender {
    IHShare *shareGo = [[IHShare alloc] initWithImage:[self getSharingImage] triggerView:sender];
    shareGo.shareDelegate = self;
    
    shareGo.shareSuccessHandler = ^(void){
        NSLog(@"Success");
        
    };
    shareGo.sharefailsHandler = ^(void){
        NSLog(@"Fails");
    };
    [shareGo showShareActionSheet];
}

- (UIImage *)getSharingImage {
    UIImage *newImg = nil;
//
//    UIImage *coverImage = self.coverImageView.image;
//    UIImage *weixinQRCodeImage = ImageNamed(@"bbq_qrcode.jpg");
//    
//    NSString *name = self.goodsDic[@"name"];
//    NSString *price = [NSString stringWithFormat:@"￥%.02f", [self.goodsDic[@"member_price"] floatValue]];
//    NSString *wexinStr = @"BBQ微信公众号";
//    
//    CGFloat margin = 4.0f;
//    CGFloat coverDisplayWidth = 320.0f;
//    CGFloat times = coverImage.size.width / coverDisplayWidth;
//    CGFloat coverDisplayHeight = coverImage.size.height / times;
//    CGFloat wexinDisplayWidth = coverDisplayWidth;
//    CGFloat shareImageWidth = coverDisplayWidth + margin * 2;
//    CGFloat shareImageHeight = coverDisplayHeight + 100 + margin * 2 + wexinDisplayWidth;
//    
//    UIFont *font = [UIFont regularSTHeitiFontOfSize:20];
//    NSDictionary *attrsDictionary =
//    [NSDictionary dictionaryWithObjectsAndKeys:
//     font, NSFontAttributeName,
//     [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(shareImageWidth, shareImageHeight));
//    [[UIColor whiteColor] set];
//    UIRectFill(CGRectMake(0, 0, shareImageWidth, shareImageHeight));
//    
//    [coverImage drawInRect:CGRectMake(margin, margin, coverDisplayWidth, coverDisplayHeight)];
//    
//    [name drawAtPoint:CGPointMake(margin, coverDisplayHeight + margin * 2) withAttributes:attrsDictionary];
//    [price drawAtPoint:CGPointMake(margin, coverDisplayHeight + margin * 2 + 25) withAttributes:attrsDictionary];
//    [wexinStr drawAtPoint:CGPointMake(margin, coverDisplayHeight + margin * 2 + 70) withAttributes:attrsDictionary];
//    
//    [weixinQRCodeImage drawInRect:CGRectMake(margin, shareImageHeight - margin - wexinDisplayWidth, wexinDisplayWidth, wexinDisplayWidth)];
//    
//    newImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
    return newImg;
}

@end
