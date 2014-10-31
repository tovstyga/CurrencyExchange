//
//  Constants.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//core data

#define MODEL_EXTENSION @"momd"

#define MODEL_NAME @"DataBase"

#define DATA_BASE_NAME @"DataBase.sqlite"

#define UNRESOLVED_ERROR @"Unresolved error %@, %@"

#define CURRENCY_TABLE_NAME @"Currency"

#define PREDICATE_FIELD_NAME @"currencyID = %@"

#define PREDICATE_FIELD_RATE @"(date = %@) AND (currencyID = %@)"

#define RATE_TABLE_NAME @"Rate"

@end

