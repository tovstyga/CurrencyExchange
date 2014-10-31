//
//  CE_TUTbyCurrency.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CETUTbyCurrency : NSObject

@property (strong, nonatomic) NSString *bankName;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *departamentName;
@property (strong, nonatomic) NSString *buyRate;
@property (strong, nonatomic) NSString *sellRate;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (strong, nonatomic) NSString *departamentAdress;

@end
