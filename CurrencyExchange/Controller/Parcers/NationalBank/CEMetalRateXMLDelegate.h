//
//  CE_MetalRateXMLDelegate.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEMetalRateXMLDelegate : NSObject<NSXMLParserDelegate>

-(NSMutableArray *)results;

@end
