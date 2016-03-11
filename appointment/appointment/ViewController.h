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

- (IBAction)onMenuButtonClicked:(id)sender;
@end

