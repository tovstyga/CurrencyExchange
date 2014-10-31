//
//  CE_NBRateDynamics.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"
#import "CECurrencyNationalBank.h"

@interface CENBRateDynamics : NSObject <IParcer>

-(void)rateDynamicForCurrency:(CECurrencyNationalBank *)currency;

@end
