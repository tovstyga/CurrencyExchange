//
//  CE_TUTParametrs.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/9/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTParametrs.h"
#import "CEBank.h"

@interface CETUTParametrs()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

#define kTUTBY_FINANCE_LIST_NAME @"TutbyFinancePropertyList"

#define kCURRENCY_KEY @"Currency"
#define kREGION @"RegionsRU"
#define kBANK @"Bank"

#define kNAME_BANK @"name"
#define kKEY_BANK @"key"
#define kCURRENCY_BANK @"currency"
#define kREGION_BANK @"region"

@implementation CETUTParametrs

-(id)init{
    self = [super init];
    if (self){
        self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kTUTBY_FINANCE_LIST_NAME ofType:@"plist"]];
    }
    return self;
}

-(NSDictionary *)currencyList{
    return [self.dictionary objectForKey:kCURRENCY_KEY];
}

-(NSDictionary *)regionsList{
    return [self.dictionary objectForKey:kREGION];
}

-(NSArray *)banks{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *bankArray = [self.dictionary objectForKey:kBANK];
    
    for (NSDictionary *dict in bankArray){
        CEBank *bank = [[CEBank alloc] init];
        
        bank.name = [dict objectForKey:kNAME_BANK];
        bank.key = [dict objectForKey:kKEY_BANK];
        bank.region = [dict objectForKey:kREGION_BANK];
        bank.currency = [dict objectForKey:kCURRENCY_KEY];
        
        [array addObject:bank];
    }
    
    return array;
}

@end
