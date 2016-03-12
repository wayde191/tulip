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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate showAdView];
    
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
    iHDINFO(@"--- %@", url);
}

- (void)menuRowClicked:(NSDictionary *)data {
    [appDelegate hideMenu];
    iHDINFO(@"--- %@", data);
}

- (IBAction)allOptionsButtonClicked:(id)sender {
    [self gotoWebViewController];
}

- (IBAction)onlyHospitalButtonClicked:(id)sender {
    [self gotoWebViewController];
}

- (IBAction)onlyDoctorButtonClicked:(id)sender {
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
        [(WebViewController *)vc setUrlString:@"http://sandbox.api.sibosen.com/test.html"];
    }
}

@end
