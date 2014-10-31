//
//  CE_NBRateDynamics.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENBRateDynamics.h"
#import "CECurrencyNationalBank.h"
#import "CENBRateDynamicsXMLParcerDelegate.h"
#import "CEDate.h"

@interface CENBRateDynamics()

@property (strong, nonatomic) NSURL *url;

@end

#define kNOTIFICATION_PARCER_NAME @"CurrencyRateDynamicLoaded"
#define kURL @"http://www.nbrb.by/Services/XmlExRatesDyn.aspx?curId=%@&fromDate=%@&toDate=%@"
#define kDATE_FORMAT @"MM/dd/YYYY"

@implementation CENBRateDynamics

-(void)rateDynamicForCurrency:(CECurrencyNationalBank *)currency{
   
    NSString *urlString = [NSString stringWithFormat:kURL, currency.currencyID, [CEDate yearAgo], [CEDate today]];
    
    self.url = [NSURL URLWithString:urlString];
   // self.url = [NSURL URLWithString:@"http://www.nbrb.by/Services/XmlExRatesDyn.aspx?curId=145&fromDate=10/14/2013&toDate=10/14/2014"];
}

-(NSURL *)url{
    return _url;
}

-(NSArray *)parceData:(NSData *)downloadData{
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:downloadData];
    
    CENBRateDynamicsXMLParcerDelegate *delegate = [[CENBRateDynamicsXMLParcerDelegate alloc] init];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:[CENBRateDynamics notificationParcerName] object:result];
    }
}

@end
