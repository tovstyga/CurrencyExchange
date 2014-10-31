//
//  CELoadingView.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/15/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CELoadingView.h"

@interface CELoadingView()

@property (strong, nonatomic) UIAlertView *alert;

@end

static CELoadingView *instance;

@implementation CELoadingView

-(instancetype)init{
    return instance;
}

+(instancetype)getInstance{
    
    static dispatch_once_t task;
    dispatch_once(&task, ^{
        instance = [[super alloc] init];
        if (instance){
            instance.alert =[[UIAlertView alloc] initWithTitle:@"Loading Data" message:@"" delegate:instance cancelButtonTitle:nil otherButtonTitles:nil];
            UIActivityIndicatorView *activity =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [activity startAnimating];
            [activity setFrame:CGRectMake(125, 60, 37, 37)];
            [instance.alert addSubview:activity];
        }
    });
    return instance;
}

-(void)show{
    [instance.alert show];
}

-(void)close{
    [instance.alert dismissWithClickedButtonIndex:0 animated:YES];
}


@end
