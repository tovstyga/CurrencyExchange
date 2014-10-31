//
//  CELoadingView.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/15/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CELoadingView : NSObject

+(instancetype)getInstance;
-(void)show;
-(void)close;

@end
