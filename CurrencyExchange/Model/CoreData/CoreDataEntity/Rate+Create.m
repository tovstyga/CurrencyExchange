//
//  Rate+Create.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "Rate+Create.h"
#import "Constants.h"

@implementation Rate (Create)

+(instancetype)createWithRate:(NSString *)rate currencyID:(NSString *)curID date:(NSDate *)date context:(NSManagedObjectContext *)context{
    
    __block Rate *rateInstance = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:RATE_TABLE_NAME];
    request.predicate = [NSPredicate predicateWithFormat:PREDICATE_FIELD_RATE, date, curID];
    
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
        rateInstance = [matches firstObject];
        
    } else {
        void(^insert)() = ^{
            rateInstance = [NSEntityDescription insertNewObjectForEntityForName:RATE_TABLE_NAME inManagedObjectContext:context];
        };
        
        [context performBlockAndWait:insert];
        
        rateInstance.currencyID = curID;
        rateInstance.date = date;
        rateInstance.rate = rate;
        
    }
    
    
    return rateInstance;

}

@end
