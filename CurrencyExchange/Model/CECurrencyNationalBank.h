//
//  CE_CurrencyNationalBank.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CECurrencyNationalBank : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *currencyID;
@property (strong, nonatomic) NSString *numCode;
@property (strong, nonatomic) NSString *charCode;
@property (strong, nonatomic) NSString *scale;
@property (strong, nonatomic) NSString *quotName;
@property (strong, nonatomic) NSString *rate;
@property (strong, nonatomic) NSString *delta;
@property (strong, nonatomic) NSAttributedString *aDelta;

@end
