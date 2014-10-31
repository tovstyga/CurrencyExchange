//
//  CE_NationalBank.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CECurrencyNationalBank.h"
#import "CEMetalsRate.h"

#define NOTIFICATION_DATA_UPDATE @"UPDATING_NB_DATA_COMPLETE"
#define NOTIFICATION_DYNAMIC @"DYNAMIC_RATE_LOAD"

@interface CENationalBank : NSObject

+(id)getInstance;
-(void)update;
-(BOOL)isUpdating;
-(void)swapCurrencyRate;

-(NSDictionary *)currencyRateData;
-(CEMetalsRate *)metalsRate;
-(NSString *)refinancingRate;
-(void)rateDynamicForCurrency:(CECurrencyNationalBank *)currency;

-(NSArray *)allCurrencyRateTodayAndMonth;

@end
