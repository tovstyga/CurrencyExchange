//
//  CE_LockWindow.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/9/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CELockWindow.h"

@interface CELockWindow()

@property (strong, nonatomic) UIView *overlayLockView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation CELockWindow

-(void)showWindowInFrame:(UIView *)superview{
    
    self.overlayLockView = [[UIView alloc] init];
    self.overlayLockView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.overlayLockView.frame = superview.bounds;
    
    CGRect frame = self.overlayLockView.frame;
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self.overlayLockView addSubview:self.indicator];
    [self.indicator startAnimating];
    
    [superview addSubview:self.overlayLockView];
}

-(void)closeWindow{
    [self.overlayLockView removeFromSuperview];
}

@end
