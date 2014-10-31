//
//  CE_CurrencyNationalBankParcer.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"

@interface CECurrencyNationalBankParcer : NSObject<IParcer>

typedef NS_ENUM(NSInteger, QueryMode) {
    TodayMode = 0,
    YesterdayMode = 1,
    TomorrowMode = 2,
    MonthMode = 3,
    BeforeMonth = 4
};

@property (nonatomic) int mode;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSArray *results;

-(instancetype)initWithQueryMode:(QueryMode)mode;

@end
