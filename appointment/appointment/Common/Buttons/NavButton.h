//
//  NavButton.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/12/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "BBQBaseView.h"

@interface NavButton : BBQBaseView

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

- (void)makeAsLeftNavigationButton;
- (void)makeAsRightNavigationButton;

@end
