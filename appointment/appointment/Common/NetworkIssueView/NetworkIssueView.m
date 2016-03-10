//
//  SegmentView.m
//  MonkeyKing
//
//  Created by Wayde Sun on 12/18/14.
//  Copyright (c) 2014 MK. All rights reserved.
//

#import "NetworkIssueView.h"

@implementation NetworkIssueView

- (IBAction)onSecondBtnClicked:(id)sender {
    if (self.vchangedBlock) {
        self.vchangedBlock(self);
    }
}
@end
