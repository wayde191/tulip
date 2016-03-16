//
//  MenuRowView.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/11/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "BBQBaseView.h"

@interface MenuRowView : BBQBaseView

@property (nonatomic, strong) NSDictionary *dataDic;

typedef void (^menuRowClickedBlock)(NSDictionary *data);
@property (copy, nonatomic) menuRowClickedBlock menuClickedBlock;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *theButton;

- (IBAction)onMenuClicked:(id)sender;
- (void)setupMenu:(NSDictionary *)data;
@end
