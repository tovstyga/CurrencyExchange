//
//  Currency+Create.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "Currency.h"
#import "CECurrencyNationalBank.h"

@interface Currency (Create)

+(instancetype)createWithCurrencyNationalBank:(CECurrencyNationalBank *)currencyNB useBackgroundContext:(NSManagedObjectContext *)context;

@end
