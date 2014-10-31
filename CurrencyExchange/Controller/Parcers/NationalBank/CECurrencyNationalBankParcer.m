//
//  CE_CurrencyNationalBankParcer.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CECurrencyNationalBankParcer.h"
#import "CENBRateXMLParcerDelegate.h"
#import "CEDate.h"

@interface CECurrencyNationalBankParcer()

@end

#define kNOTIFICATION_PARCER_NAME @"CurrencyNationalBankLoaded"
#define kBASIC_URL_STRING @"http://www.nbrb.by/Services/XmlExRates.aspx?mode=1&ondate=%@"
#define kPERIOD_KEY @"&period=1"

@implementation CECurrencyNationalBankParcer

-(id)init{
    return nil;
}

-(instancetype)initWithQueryMode:(QueryMode)mode{
    self = [super init];
    
    if (self){
        self.mode = mode;
        if (mode == TodayMode){
            NSString *urlStirng = [NSString stringWithFormat:kBASIC_URL_STRING, [CEDate today]];
            _url = [NSURL URLWithString:urlStirng];
          
        } else if (mode == YesterdayMode){
            NSString *urlStirng = [NSString stringWithFormat:kBASIC_URL_STRING, [CEDate yesterday]];
            _url = [NSURL URLWithString:urlStirng];
          
        } else if (mode == TomorrowMode){
            NSString *urlStirng = [NSString stringWithFormat:kBASIC_URL_STRING, [CEDate tomorrow]];
            _url = [NSURL URLWithString:urlStirng];
           
        } else if (mode == MonthMode){
            NSString *urlString = [NSString stringWithFormat:kBASIC_URL_STRING, [CEDate today]];
            urlString = [urlString stringByAppendingString:kPERIOD_KEY];
            self.url = [NSURL URLWithString:urlString];
           
        } else if (mode == BeforeMonth){
            NSString *urlString = [NSString stringWithFormat:kBASIC_URL_STRING, [CEDate monthBefore]];
            urlString = [urlString stringByAppendingString:kPERIOD_KEY];
            self.url = [NSURL URLWithString:urlString];
          
        }
    }
    
    return self;
}

-(NSURL *)url{
    
    return _url;
}


-(NSArray *)parceData:(NSData *)downloadData{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:downloadData];
    
    CENBRateXMLParcerDelegate *delegate = [[CENBRateXMLParcerDelegate alloc] init];
       
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

        self.results = [self parceData:data];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[CECurrencyNationalBankParcer notificationParcerName] object:self];
    }

}

@end
