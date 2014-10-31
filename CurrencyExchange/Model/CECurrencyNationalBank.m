//
//  CE_CurrencyNationalBank.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CECurrencyNationalBank.h"
#import <UIKit/UIKit.h>

@implementation CECurrencyNationalBank

-(void)setDelta:(NSString *)delta{

    _delta = delta;
    
    float f = [_delta floatValue];
    
    int i = roundf(f);
    NSString *value = [NSString stringWithFormat:@"%i", i];
    
    NSMutableAttributedString *aString;
    
    if (i == 0){
        aString = [[NSMutableAttributedString alloc] initWithString:@"---"];
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,2)];

    } else if (i < 0){
        
        aString = [[NSMutableAttributedString alloc] initWithString:value];
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,value.length)];
        
    } else if (i > 0){
        value = [NSString stringWithFormat:@"+%@", value];
        aString = [[NSMutableAttributedString alloc] initWithString:value];
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,value.length)];
        
    }
    
    self.aDelta = aString;
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"[\n date = %@ \n id = %@ \n numcode = %@ \n charcode = %@ \n scale = %@ \n quotname = %@ \n rate = %@ \n ]",self.date, self.currencyID, self.numCode, self.charCode, self.scale, self.quotName, self.rate];
}

@end
