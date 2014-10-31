//
//  CETUTDetails.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTDetails.h"

@implementation CETUTDetails

-(instancetype)init{
    self = [super init];
    if (self){
        self.services = [[NSMutableArray alloc] init];
        self.currency = [[NSMutableArray alloc] init];
        self.info = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
