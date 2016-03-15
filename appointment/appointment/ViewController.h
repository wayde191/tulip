//
//  ViewController.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/9/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "BBQBaseViewController.h"

@interface ViewController : BBQBaseViewController

- (void)adClicked:(NSString *)url;
- (void)menuRowClicked:(NSDictionary *)data;
- (void)notificationReveived:(NSString *)url;
- (IBAction)allOptionsButtonClicked:(id)sender;
- (IBAction)onlyHospitalButtonClicked:(id)sender;
- (IBAction)onlyDoctorButtonClicked:(id)sender;

- (IBAction)onMenuButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTop1Constraint;

@end

