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

- (void)setupMenu:(NSDictionary *)data {
    self.dataDic = data;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"icon"]]];
    [self.textLabel setText:_dataDic[@"text"]];
}

- (IBAction)onMenuClicked:(id)sender {
    if (self.menuClickedBlock) {
        self.menuClickedBlock(_dataDic);
    }
}
@end
