//
//  Rate.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Currency;

@interface Rate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * rate;
@property (nonatomic, retain) NSString * currencyID;
@property (nonatomic, retain) Currency *currency;

@end
