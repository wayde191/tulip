//
//  SegmentView.h
//  MonkeyKing
//
//  Created by Wayde Sun on 12/18/14.
//  Copyright (c) 2014 MK. All rights reserved.
//

#import "BBQBaseView.h"

@interface KeyboardView : BBQBaseView {
}

typedef void (^KeyboardAssistantBlock)(KeyboardView *keyboard);
@property (copy, nonatomic) KeyboardAssistantBlock vchangedBlock;

- (IBAction)onSecondBtnClicked:(id)sender;
@end
