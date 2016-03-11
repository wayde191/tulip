//
//  ViewController.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/9/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "ViewController.h"

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

- (IBAction)onMenuButtonClicked:(id)sender {
    [appDelegate showMenu];
}

@end
