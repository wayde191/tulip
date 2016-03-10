//
//  AdView.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/10/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "BBQBaseView.h"

@interface AdView : BBQBaseView

typedef void (^AdClickedBlock)(NSString *url);
@property (copy, nonatomic) AdClickedBlock adClickedBlock;

@property (weak, nonatomic) IBOutlet UIView *noAdView;
@property (weak, nonatomic) IBOutlet UIView *theAdView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) NSDictionary *adInfoDic;

- (void)showAds:(NSDictionary *)adDic;
- (IBAction)onAdClicked:(UIButton *)sender;
@end
