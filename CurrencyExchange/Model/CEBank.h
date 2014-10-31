//
//  CE_Bank.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/9/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEBank : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSArray *currency;
@property (strong, nonatomic) NSArray *region;

@end
