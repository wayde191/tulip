//
//  ViewController.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/9/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "IHShare.h"

//1 靠谱的医生－ http://tulip.sibosen.com/inquiry/step1.html
//2 指定医院－ http://tulip.sibosen.com/search/city.html
//3 指定医生－ http://tulip.sibosen.com/search/doctor.html

#define HOME_URL_1      @"http://tulip.sibosen.com/inquiry/step1.html"
#define HOME_URL_2      @"http://tulip.sibosen.com/search/city.html"
#define HOME_URL_3      @"http://tulip.sibosen.com/search/doctor.html"

#define HOME_TEST_URL   @"http://sandbox.api.sibosen.com/ios.html"

@interface ViewController (){
    NSString *_selectedUrl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate showAdView];
    
    [self setupConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}

#pragma mark - Public Method
- (void)adClicked:(NSString *)url {
    [appDelegate hideAdView];
    _selectedUrl = url;
    [self gotoWebViewController];
    iHDINFO(@"--- %@", url);
}

- (void)menuRowClicked:(NSDictionary *)data {
    [appDelegate hideMenu];
    _selectedUrl = data[@"url"];
    [self gotoWebViewController];
    iHDINFO(@"--- %@", data);
}

- (void)notificationReveived:(NSString *)url {
    if (url) {
        _selectedUrl = url;
        [self gotoWebViewController];
    }
}

- (IBAction)allOptionsButtonClicked:(id)sender {
    _selectedUrl = HOME_URL_1;
    [self gotoWebViewController];
}

- (IBAction)onlyHospitalButtonClicked:(id)sender {
    _selectedUrl = HOME_URL_2;
    [self gotoWebViewController];
}

- (IBAction)onlyDoctorButtonClicked:(id)sender {
    _selectedUrl = HOME_URL_3;
    [self gotoWebViewController];
}

- (IBAction)onMenuButtonClicked:(id)sender {
    [appDelegate showMenu];
}

- (void)gotoWebViewController {
    [self performSegueWithIdentifier:@"WebViewController" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id vc = segue.destinationViewController;
    if ([vc isKindOfClass:[WebViewController class]]) {
        [(WebViewController *)vc setUrlString:_selectedUrl];
    }
}

#pragma mark - Private Methods
- (void)setupConstraint {
    
    iHDINFO(@"---%@", self.view);
    
    if (IS_IPHONE_5) {
        self.firstTop1Constraint.constant = 10;
        self.secondTopConstraint.constant = 10;
        self.thirdTopConstraint.constant = 10;
        
    } else if (IS_IPHONE_6) {
        
    } else if (IS_IPHONE_6_PLUS) {

    }
}

@end
