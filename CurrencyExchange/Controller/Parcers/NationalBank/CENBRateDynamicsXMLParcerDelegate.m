//
//  CE_NBRateDynamicsXMLParcerDelegate.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENBRateDynamicsXMLParcerDelegate.h"

@interface CENBRateDynamicsXMLParcerDelegate()

@property (strong, nonatomic) NSMutableDictionary *objects;
@property (strong, nonatomic) NSDateFormatter *formatter;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *rate;

@end

#define kRATE @"Rate"
#define kDATE @"Date"

#define kDATE_FORMAT_STRING @"MM/dd/yyyy"

@implementation CENBRateDynamicsXMLParcerDelegate

-(NSMutableDictionary *)results{
    return self.objects;
}

- (void) parserDidStartDocument:(NSXMLParser *)parser{
    self.objects = [[NSMutableDictionary alloc] init];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:kDATE_FORMAT_STRING];
    
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
    
    
    
    if (attributeDict.count){
        self.date = [self.formatter dateFromString:[attributeDict objectForKey:kDATE]];
    }
    
    if ([elementName isEqualToString:kRATE]){
        
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName{
   
    if ([elementName isEqualToString:kRATE]){
        [self.objects setObject:self.rate forKey:self.date];
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.rate = [[NSNumber alloc] initWithFloat:[string floatValue]];
}


@end
