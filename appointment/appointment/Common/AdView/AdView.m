//
//  AdView.m
//  appointment
//
//  Created by Wei Wayde Sun on 3/10/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "AdView.h"
#import "UIImageView+WebCache.h"
#import "iHValidationKit.h"

@implementation AdView

- (IBAction)onAdClicked:(UIButton *)sender {
    if (self.adClickedBlock) {
        self.adClickedBlock(_adInfoDic[@"url"]);
    }
}

- (void)showAds:(NSDictionary *)adDic {
    if ([iHValidationKit isValueEmpty:adDic]) {
        [self bringSubviewToFront:self.noAdView];
    } else {
        [self bringSubviewToFront:self.theAdView];
        self.adInfoDic = adDic;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_adInfoDic[@"pic"]] placeholderImage:nil];
    }
}
@end
