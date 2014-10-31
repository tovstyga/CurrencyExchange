//
//  CE_Date.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/8/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEDate.h"

@implementation CEDate

#define kDATE_FORMAT_STRING @"MM/dd/YYYY"

+(NSString *)today{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    return [CEDate toString:date];
}

+(NSString *)yesterday{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    return [CEDate toString:date];
}

+(NSString *)tomorrow{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: (60.0f*60.0f*24.0f)];
    return [CEDate toString:date];
}

+(NSString *)monthBefore{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f*31.0f)];
    return [CEDate toString:date];
}

+(NSString *)yearAgo{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f*365.0f)];
    return [CEDate toString:date];
}

+(NSString *)toString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDATE_FORMAT_STRING];
    
    return [formatter stringFromDate:date];
}

@end
