//
//  WebViewController.h
//  appointment
//
//  Created by Wei Wayde Sun on 3/11/16.
//  Copyright © 2016 tulip. All rights reserved.
//

#import "BBQBaseViewController.h"

@interface WebViewController : BBQBaseViewController <ISSShareViewDelegate> {
    NSMutableArray *_trustedHosts;
}

@property (strong, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end