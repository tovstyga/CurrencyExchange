//
//  CE_TUTbyCurrency.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTbyCurrency.h"

@implementation CETUTbyCurrency


-(NSString *)description{
    return [NSString stringWithFormat:@"[ bank name : %@ \n url : %@ \n departamentName : %@ \n buyRate : %@ \n sellRate : %@ \n longitude : %f \n latitude : %f \n departament adress : %@]", _bankName, _url, _departamentName, _buyRate, _sellRate, _longitude, _latitude, _departamentAdress];
}

@end
