//
//  CEEntityManager.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEEntityManager : NSObject

-(void)saveCurrencyNBObjects:(NSArray *)objects;
-(NSArray *)loadObjects;


@end
