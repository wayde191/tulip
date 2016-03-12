//
//  NavButton.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/12/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton

- (void)makeAsLeftNavigationButton {
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
}

- (void)makeAsRightNavigationButton {
    self.leftView.hidden = YES;
    self.rightView.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
