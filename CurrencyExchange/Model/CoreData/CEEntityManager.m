//
//  CEEntityManager.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEEntityManager.h"
#import "CECurrencyNationalBank.h"
#import "CEDataBaseDirector.h"
#import "Currency+Create.h"
#import "Rate.h"
#import "Constants.h"
#import <CoreData/CoreData.h>

@implementation CEEntityManager

-(void)saveCurrencyNBObjects:(NSArray *)objects{
    if (objects.count){
        
        NSManagedObjectContext *context = [[CEDataBaseDirector instance] contextForBGTask];
        for (CECurrencyNationalBank *currency in objects){
            [Currency createWithCurrencyNationalBank:currency useBackgroundContext:context];
        }
        
        [[CEDataBaseDirector instance] saveContextForBGTask:context];

    }
}

-(NSMutableArray *)loadObjects{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CURRENCY_TABLE_NAME];
    
    NSManagedObjectContext *context = [[CEDataBaseDirector instance] contextForBGTask];
    
    __block NSArray *matches;
    
    void (^executeFetch)() = ^{
        NSError *error;
        matches = [context executeFetchRequest:fetchRequest error:&error];
    };
    
    [context performBlockAndWait:executeFetch];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    for (Currency *cur in matches){
        
        NSArray *rates = [[cur.rate allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        CECurrencyNationalBank *currencyNB = [[CECurrencyNationalBank alloc] init];
        
        currencyNB.currencyID = cur.currencyID;
        currencyNB.numCode = cur.numCode;
        currencyNB.charCode = cur.charCode;
        currencyNB.scale = cur.scale;
        currencyNB.quotName = cur.quotName;
        
        if (rates.count){
            Rate *rate = (Rate *)[rates lastObject];
            currencyNB.rate = rate.rate;
            currencyNB.date = rate.date;
            if (rates.count > 1){
                Rate *yesterdayRate = (Rate *)[rates objectAtIndex:rates.count - 2];
                float todayRate = [rate.rate floatValue];
                float ydayRate = [yesterdayRate.rate floatValue];
                float result = todayRate - ydayRate;
                currencyNB.delta = [NSString stringWithFormat:@"%f", result];
            }
        }
        
        [objects addObject:currencyNB];
        
    }
    
    return objects;
}


@end
