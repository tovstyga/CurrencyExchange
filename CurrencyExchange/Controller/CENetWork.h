//
//  CE_NetWork.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"

@interface CENetWork : NSObject

-(void)downloadDataAndUseParcer:(id<IParcer>)delegate;

@end
