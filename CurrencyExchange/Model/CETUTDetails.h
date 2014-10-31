//
//  CETUTDetails.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CETUTDetails : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;

@property (strong, nonatomic) NSString *adress;

@property (strong, nonatomic) NSMutableArray *info;

@property (strong, nonatomic) NSMutableArray *services;

@property (strong, nonatomic) NSMutableArray *currency;

@end
