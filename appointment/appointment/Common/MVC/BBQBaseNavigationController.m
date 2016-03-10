//
//  BBQBaseNavigationController.m
//  BBQ
//
//  Created by Wei Wayde Sun on 8/24/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#import "BBQBaseNavigationController.h"

@interface BBQBaseNavigationController ()

@end

@implementation BBQBaseNavigationController

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor clearColor], UITextAttributeTextShadowColor,
                                              [UIColor whiteColor],UITextAttributeTextColor,
                                              [UIFont systemFontOfSize:18],UITextAttributeFont,
                                              nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationBar.translucent = FALSE;
        self.navigationBar.barTintColor = [UIColor whiteColor];
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
