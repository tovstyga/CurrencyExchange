//
//  CEImageView.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/15/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEImageView.h"

@implementation CEImageView

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    
    CGContextMoveToPoint(context, 10, 10);
    
    CGContextAddLineToPoint(context, 30, 30);
    
    CGContextStrokePath(context);
    
    
}

-(void)drawRect:(CGRect)rect forViewPrintFormatter:(UIViewPrintFormatter *)formatter{

    [super drawRect:rect forViewPrintFormatter:formatter];

}

@end
