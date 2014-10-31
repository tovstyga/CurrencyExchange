//
//  CESettings.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/13/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CESettings : NSObject

@property (strong, nonatomic) NSMutableArray *favoriteCurrency;
@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSMutableArray *convertCurrency;

-(void)save;

@end
