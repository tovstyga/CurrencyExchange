//
//  CETUTParcerDetail.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IParcer.h"

@interface CETUTParcerDetail : NSObject <IParcer>

-(instancetype)initWithURL:(NSURL *)url;

@end
