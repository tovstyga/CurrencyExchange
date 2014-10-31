//
//  Rate+Create.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "Rate.h"

@interface Rate (Create)

+(instancetype)createWithRate:(NSString *)rate currencyID:(NSString *)curID date:(NSDate *)date context:(NSManagedObjectContext *)context;

@end
