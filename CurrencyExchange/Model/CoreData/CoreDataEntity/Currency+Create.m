//
//  Currency+Create.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "Currency+Create.h"
#import "CEDataBaseDirector.h"
#import "Constants.h"
#import "Rate+Create.h"

@implementation Currency (Create)

+(instancetype)createWithCurrencyNationalBank:(CECurrencyNationalBank *)currencyNB useBackgroundContext:(NSManagedObjectContext *)context{
    
    __block Currency *currency = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CURRENCY_TABLE_NAME];
    request.predicate = [NSPredicate predicateWithFormat:PREDICATE_FIELD_NAME, currencyNB.currencyID];
    
    __block NSError *error;
    
    __block NSArray *matches;
    
    
    void (^executeFetch)() = ^{
        //NSError *error;
        matches = [context executeFetchRequest:request error:&error];
    };
    
    [context performBlockAndWait:executeFetch];
    
    if (!matches || error || ([matches count] > 1)){
        //NSLog(@"error request");
    } else if ([matches count]){
        currency = [matches firstObject];
        
        Rate *rate = [Rate createWithRate:currencyNB.rate currencyID:currencyNB.currencyID date:currencyNB.date context:context];
        
        rate.currency = currency;
        
        [currency addRateObject:rate];
        
        
    } else {
        void(^insert)() = ^{
            currency = [NSEntityDescription insertNewObjectForEntityForName:CURRENCY_TABLE_NAME inManagedObjectContext:context];
        };
        
        [context performBlockAndWait:insert];
        
        currency.currencyID = currencyNB.currencyID;
        currency.numCode = currencyNB.numCode;
        currency.charCode = currencyNB.charCode;
        currency.scale = currencyNB.scale;
        currency.quotName = currencyNB.quotName;
        
        Rate *rate = [Rate createWithRate:currencyNB.rate currencyID:currencyNB.currencyID date:currencyNB.date context:context];
        
        rate.currency = currency;
        
        [currency addRateObject:rate];
    }

    return currency;
}

@end
