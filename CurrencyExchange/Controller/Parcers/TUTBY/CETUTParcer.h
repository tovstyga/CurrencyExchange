//
//  CE_TUTParcer.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"

@interface CETUTParcer : NSObject <IParcer>

@property (strong, nonatomic) NSMutableArray *objects;
@property (nonatomic) BOOL hasNext;

-(instancetype)initWithURL:(NSURL *)url;

@end
