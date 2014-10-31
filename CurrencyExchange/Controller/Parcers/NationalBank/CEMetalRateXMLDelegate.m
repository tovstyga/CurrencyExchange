//
//  CE_MetalRateXMLDelegate.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEMetalRateXMLDelegate.h"

@interface CEMetalRateXMLDelegate()

@property (strong, nonatomic) NSMutableArray *objects;

@end

static NSString *tempString;

#define kPRICE @"Price"

@implementation CEMetalRateXMLDelegate

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
    
    if ([elementName isEqualToString:kPRICE]){
        tempString = @"";
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:kPRICE]){
        [self.objects addObject:tempString];
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    tempString = string;
}


@end
