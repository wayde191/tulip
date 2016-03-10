//
//  NotificationView.h
//  iFinancial
//
//  Created by Wayde Sun on 5/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#import "BBQBaseView.h"

@interface NotificationView : BBQBaseView

@property (weak, nonatomic) IBOutlet UILabel *errLabel;
- (IBAction)onCloseBtnClicked:(id)sender;

- (void)showMsg:(NSString *)msg;
- (void)showStaticMsg:(NSString *)msg;

- (void)hideMsg;
@end
