//
//  NotificationView.m
//  iFinancial
//
//  Created by Wayde Sun on 5/1/14.
//  Copyright (c) 2014 iHakula. All rights reserved.
//

#define NOTIFICATION_VIEW_TOP       130.0f

#import "NotificationView.h"
#import "MenuRowView.h"

@interface NotificationView () {
}

@end

@implementation NotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left = -1 * IH_DEVICE_WIDTH;
    self.top = 0;
}

- (void)menuClicked:(NSDictionary *)data {
    if (self.menuClickedBlock) {
        self.menuClickedBlock(data);
    }
}

- (void)setupMenu:(NSArray *)data {
    self.menuDataArr = data;
    [_menuContainer removeAllSubviews];
    
    NotificationView __weak *weakself = self;
    for (int i = 0; i < _menuDataArr.count; i++) {
        MenuRowView *row = [MenuRowView viewFromNib];
        row.width = _menuContainer.width;
        row.left = 0;
        row.top = i * row.height;
        
        row.menuClickedBlock = ^(NSDictionary *data){
            [weakself menuClicked:data];
        };
        [row setupMenu:_menuDataArr[i]];
        [_menuContainer addSubview:row];
    }
}

- (void)showMenu {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.left = 0;
    }];
}

- (void)hideMenu {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.left = -1 * IH_DEVICE_WIDTH;
    } completion:^(BOOL finished) {
    }];
}

//- (void)showMsg:(NSString *)msg {
//    _errLabel.text = msg;
//    [UIView cancelPreviousPerformRequestsWithTarget:self];
//    
//    [UIView animateWithDuration:.3 animations:^(){
//        if (IS_IPAD) {
//            if (IS_IOS_8) {
//                if(UIDeviceOrientationIsLandscape(g_currDeviceOrientation)){
//                    self.left = IPAD_SCREEN_HEIGHT - 191;
//                } else {
//                    self.left = IPAD_SCREEN_WIDTH - self.width;
//                }
//                
//            } else {
//                
//                if( UIDeviceOrientationLandscapeLeft == g_currDeviceOrientation ) {
//                    self.top = IPAD_SCREEN_HEIGHT - self.height;
//                    self.left = IPAD_SCREEN_WIDTH - NOTIFICATION_VIEW_TOP;
//                    
//                } else if ( UIDeviceOrientationPortrait == g_currDeviceOrientation ) {
//                    self.top = NOTIFICATION_VIEW_TOP;
//                    self.left = IPAD_SCREEN_WIDTH - self.width;
//                    
//                } else if ( UIDeviceOrientationLandscapeRight == g_currDeviceOrientation) {
//                    self.left = 100;
//                    self.top = 0;
//                    
//                } else if ( UIDeviceOrientationPortraitUpsideDown == g_currDeviceOrientation) {
//                    self.left = 0;
//                    self.top = IPAD_SCREEN_HEIGHT - NOTIFICATION_VIEW_TOP;
//                }
//            }
//            
//        } else { // iphone
//            self.left = IPHONE_SCREEN_WIDTH - self.width;
//        }
//        
//    } completion:^(BOOL finished) {
//        [self performSelector:@selector(hideMsg) withObject:self afterDelay:2.0];
//    }];
//}
//
//- (void)showStaticMsg:(NSString *)msg{
//    _errLabel.text = msg;
//    [UIView cancelPreviousPerformRequestsWithTarget:self];
//    
//    [UIView animateWithDuration:.3 animations:^(){
//        if (IS_IPAD) {
//            if (IS_IOS_8) {
//                if(UIDeviceOrientationIsLandscape(g_currDeviceOrientation)){
//                    self.left = IPAD_SCREEN_HEIGHT - 191;
//                } else {
//                    self.left = IPAD_SCREEN_WIDTH - self.width;
//                }
//                
//            } else {
//                if(UIDeviceOrientationIsLandscape(g_currDeviceOrientation)){
//                    self.left = IPAD_SCREEN_HEIGHT - self.width;
//                } else {
//                    self.left = IPAD_SCREEN_WIDTH - self.width;
//                }
//            }
//        } else {
//            self.left = IPHONE_SCREEN_WIDTH - self.width;
//        }
//    } completion:^(BOOL finished) {
//    }];
//}
//
//- (void)hideMsg {
//    [UIView cancelPreviousPerformRequestsWithTarget:self];
//    [UIView animateWithDuration:.3 animations:^{
//        if (IS_IPAD) {
//            if (IS_IOS_8) {
//                self.left = IPAD_SCREEN_HEIGHT;
//                
//            } else {
//                if( UIDeviceOrientationLandscapeLeft == g_currDeviceOrientation ) {
//                    [self UIDeviceOrientationLandscapeLeftHide];
//                } else if( UIDeviceOrientationPortrait == g_currDeviceOrientation) {
//                    [self UIDeviceOrientationPortraitHide];
//                } else if ( UIDeviceOrientationLandscapeRight == g_currDeviceOrientation) {
//                    [self UIDeviceOrientationLandscapeRightHide];
//                } else if ( UIDeviceOrientationPortraitUpsideDown == g_currDeviceOrientation) {
//                    [self UIDeviceOrientationPortraitUpsideDownHide];
//                }
//            }
//        } else { // iphone
//            self.left = IPHONE_SCREEN_WIDTH;
//        }
//        
//    } completion:^(BOOL finished) {
//        _errLabel.text = @"";
//    }];
//}
//
//#pragma mark -
//#pragma mark Rotation
//
////| ----------------------------------------------------------------------------
////! Handler for the UIDeviceOrientationDidChangeNotification.
////
//- (void)onDeviceOrientationDidChange:(NSNotification *)notification
//{
//    // A delay must be added here, otherwise the new view will be swapped in
//    // too quickly resulting in an animation glitch
//    [self performSelector:@selector(updateLandscapeView) withObject:nil afterDelay:0];
//}
//
////| ----------------------------------------------------------------------------
////  This method contains the logic for presenting and dismissing the
////  LandscapeViewController depending on the current device orientation and
////  whether the LandscapeViewController is currently presented.
////
//- (void)updateLandscapeView
//{
//    // Get the device's current orientation.  By the time the
//    // UIDeviceOrientationDidChangeNotification has been posted, this value
//    // reflects the new orientation of the device.
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    if (deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationFaceDown) {
//        deviceOrientation = (NSInteger)[UIDevice currentOrientation];
//    }
//    
//    g_currDeviceOrientation = deviceOrientation;
//    
//    if (IS_IOS_8) {
//        return;
//    }
//    
//    if (UIDeviceOrientationPortrait == deviceOrientation) { // 0 degree
//        
//        [UIView animateWithDuration:0 animations:^{
//            self.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
//        }];
//        [self UIDeviceOrientationPortraitHide];
//        
//    } else if (UIDeviceOrientationLandscapeLeft == deviceOrientation) { // 90 degree
//        
//        [UIView animateWithDuration:0 animations:^{
//            self.layer.transform = CATransform3DMakeRotation(0.5 * M_PI, 0, 0, 1);
//        }];
//        [self UIDeviceOrientationLandscapeLeftHide];
//        
//    } else if (UIDeviceOrientationLandscapeRight == deviceOrientation) { // 270 degree
//        
//        [UIView animateWithDuration:0 animations:^{
//            self.layer.transform = CATransform3DMakeRotation(1.5 * M_PI, 0, 0, 1);
//        }];
//        [self UIDeviceOrientationLandscapeRightHide];
//        
//    } else if (UIDeviceOrientationPortraitUpsideDown == deviceOrientation) {
//        
//        // UIDeviceOrientationPortraitUpsideDown 180
//        [UIView animateWithDuration:0 animations:^{
//            self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        }];
//        [self UIDeviceOrientationPortraitUpsideDownHide];
//        
//    }
//}
//
//- (void)UIDeviceOrientationLandscapeLeftHide {
//    self.top = IPAD_SCREEN_HEIGHT;
//    self.left = IPAD_SCREEN_WIDTH - NOTIFICATION_VIEW_TOP;
//}
//
//- (void)UIDeviceOrientationLandscapeRightHide {
//    self.left = 100;
//    self.top = 0 - self.height;
//}
//
//- (void)UIDeviceOrientationPortraitHide {
//    self.top = NOTIFICATION_VIEW_TOP;
//    self.left = IPAD_SCREEN_WIDTH;
//}
//
//- (void)UIDeviceOrientationPortraitUpsideDownHide {
//    self.left = 0 - self.width;
//    self.top = IPAD_SCREEN_HEIGHT - NOTIFICATION_VIEW_TOP;
//}

#pragma mark -
#pragma mark Cleanup
@end
