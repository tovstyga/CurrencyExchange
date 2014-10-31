//
//  CE_Date.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/8/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEDate : NSObject

+(NSString *)today;
+(NSString *)yesterday;
+(NSString *)tomorrow;

+(NSString *)monthBefore;

+(NSString *)yearAgo;
+(NSString *)toString:(NSDate *)date;

@end
