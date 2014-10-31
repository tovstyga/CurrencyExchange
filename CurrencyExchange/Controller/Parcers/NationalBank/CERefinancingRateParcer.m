//
//  CE_RefinancingRateParcer.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CERefinancingRateParcer.h"
#import "CERefinancingRateParcerDelegate.h"

#define kURL @"http://www.nbrb.by/Services/XmlRefRate.aspx?onDate=%@"
#define kNOTIFICATION_PARCER_NAME @"RefinancingRateLoaded"
#define kDATE_FORMAT_STRING @"MM/dd/YYYY"

@implementation CERefinancingRateParcer

-(NSURL *)url{
    return [NSURL URLWithString:[NSString stringWithFormat:kURL, [self dateString]]];
}

-(NSArray *)parceData:(NSData *)downloadData{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:downloadData];
    
    CERefinancingRateParcerDelegate *delegate = [[CERefinancingRateParcerDelegate alloc] init];
    [parser setDelegate:delegate];
    
    [parser parse];
    
    if ([parser parserError]){
        NSLog(@"%@", [parser parserError]);
    }
    
    return [delegate results];
}

+(NSString *)notificationParcerName{
    return kNOTIFICATION_PARCER_NAME;
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (data){
        NSArray *result = [[NSArray alloc] init];
        result = [self parceData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CERefinancingRateParcer notificationParcerName] object:result];
    }
    
}

-(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDATE_FORMAT_STRING];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    
    return [formatter stringFromDate:date];
}

@end
