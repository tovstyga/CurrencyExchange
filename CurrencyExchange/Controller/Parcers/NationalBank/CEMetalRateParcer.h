//
//  CE_MetalRateParcer.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"

@interface CEMetalRateParcer : NSObject<IParcer>

@property (strong, nonatomic) NSString *metalID;
@property (strong, nonatomic) NSArray *results;

-(instancetype)initWithMetalID:(NSString *)ID;

@end
