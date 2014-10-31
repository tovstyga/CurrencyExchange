//
//  CE_NBRateXMLParcerDelegate.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENBRateXMLParcerDelegate.h"
#import "CECurrencyNationalBank.h"

@interface CENBRateXMLParcerDelegate()

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) CECurrencyNationalBank *currency;
@property (strong, nonatomic) NSDate *date;

@end

static NSString *tempString;

@implementation CENBRateXMLParcerDelegate

#define kMONTHLY_EX_RATES @"MonthlyExRates"
#define kDAILY_EX_RATES @"DailyExRates"
#define kDATE @"Date"
#define kCURRENCY @"Currency"
#define kID @"Id"
#define kNUM_CODE @"NumCode"
#define kCHAR_CODE @"CharCode"
#define kSCALE @"Scale"
#define kQUOT_NAME @"QuotName"
#define kRATE @"Rate"

#define kDATE_FORMAT_STRING @"MM/dd/YYYY"


-(NSMutableArray *)results{
    return self.objects;
}

- (void) parserDidStartDocument:(NSXMLParser *)parser{
    self.objects = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser{
    
}
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"parce error");
}
- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    NSLog(@"validation error");
}
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict{
    
    
    if ([elementName isEqualToString:kDAILY_EX_RATES] || [elementName isEqualToString:kMONTHLY_EX_RATES]){
       
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:kDATE_FORMAT_STRING];
            
            NSString *dateString = [attributeDict objectForKey:kDATE];
            
            self.date = [formatter dateFromString:dateString];
    
    } else if ([elementName isEqualToString:kCURRENCY]){
        
        self.currency = [[CECurrencyNationalBank alloc] init];
        self.currency.date = self.date;
        self.currency.currencyID = [attributeDict objectForKey:kID];
        
    }
    
    tempString = @"";
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:kCURRENCY]){
        [self.objects addObject:self.currency];
    } else if ([elementName isEqualToString:kNUM_CODE]){
        self.currency.numCode = tempString;
    } else if ([elementName isEqualToString:kCHAR_CODE]){
        self.currency.charCode = tempString;
    } else if ([elementName isEqualToString:kSCALE]){
        self.currency.scale = tempString;
    } else if ([elementName isEqualToString:kQUOT_NAME]){
        self.currency.quotName = tempString;
    } else if ([elementName isEqualToString:kRATE]){
        self.currency.rate = tempString;
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
       
    tempString = [tempString stringByAppendingString:string];
    
}

@end
