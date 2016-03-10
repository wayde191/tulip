//
//  SegmentView.h
//  MonkeyKing
//
//  Created by Wayde Sun on 12/18/14.
//  Copyright (c) 2014 MK. All rights reserved.
//

#import "BBQBaseView.h"

@interface NetworkIssueView : BBQBaseView {
}

typedef void (^NetworkIssueBlock)(NetworkIssueView *keyboard);
@property (copy, nonatomic) NetworkIssueBlock vchangedBlock;

- (IBAction)onSecondBtnClicked:(id)sender;
@end
