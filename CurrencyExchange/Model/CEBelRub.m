//
//  CEBelRub.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/17/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEBelRub.h"

@implementation CEBelRub

+(CECurrencyNationalBank *)defaultCurrency{

        CECurrencyNationalBank *belRUB = [[CECurrencyNationalBank alloc] init];
        belRUB.charCode = @"BYR";
        belRUB.scale = @"1";
        belRUB.quotName = @"Белорусский рубль";
        belRUB.rate = @"1";
    
    return belRUB;
    
}

@end
