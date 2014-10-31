//
//  Currency.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rate;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * currencyID;
@property (nonatomic, retain) NSString * charCode;
@property (nonatomic, retain) NSString * numCode;
@property (nonatomic, retain) NSString * scale;
@property (nonatomic, retain) NSString * quotName;
@property (nonatomic, retain) NSSet *rate;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addRateObject:(Rate *)value;
- (void)removeRateObject:(Rate *)value;
- (void)addRate:(NSSet *)values;
- (void)removeRate:(NSSet *)values;

@end
