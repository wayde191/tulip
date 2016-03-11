//
//  NotificationView.h
//  iFinancial
//
//  Created by Wayde Sun on 5/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "BBQBaseView.h"

@interface NotificationView : BBQBaseView

typedef void (^menuClickedBlock)(NSDictionary *data);
@property (copy, nonatomic) menuClickedBlock menuClickedBlock;

@property (strong, nonatomic) NSArray *menuDataArr;
@property (weak, nonatomic) IBOutlet UIView *menuContainer;

- (void)showMenu;
- (void)hideMenu;

- (void)setupMenu:(NSArray *)data;
@end
