//
//  NotificationView.h
//  iFinancial
//
//  Created by Wayde Sun on 5/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "BBQBaseView.h"

@interface NotificationView : BBQBaseView <UIGestureRecognizerDelegate>

typedef void (^menuClickedBlock)(NSDictionary *data);
@property (copy, nonatomic) menuClickedBlock menuClickedBlock;

@property (strong, nonatomic) NSArray *menuDataArr;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *menuMainView;

- (void)showMenu;
- (void)hideMenu;

- (IBAction)onBackgroundClicked:(id)sender;
- (void)setupMenu:(NSArray *)data;
@end
