//
//  MenuRowView.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/11/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "MenuRowView.h"
#import "UIImageView+WebCache.h"

@implementation MenuRowView

- (void)awakeFromNib {
    [self.theButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.theButton addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchDragOutside];
    [self.theButton addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)clearBg {
    [self touchUp];
}

- (void)touchDown {
//    self.textLabel.textColor = [UIColor lightGrayColor];
    self.backgroundColor = MENU_HOVER_BG_COLOR;
}

- (void)touchUp {
//    self.textLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupMenu:(NSDictionary *)data {
    self.dataDic = data;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"icon"]]];
    [self.textLabel setText:_dataDic[@"text"]];
}

- (IBAction)onMenuClicked:(id)sender {
    if (self.menuClickedBlock) {
        self.menuClickedBlock(_dataDic);
        [self touchUp];
    }
}
@end
