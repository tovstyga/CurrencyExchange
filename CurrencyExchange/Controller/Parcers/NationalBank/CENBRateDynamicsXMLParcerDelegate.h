//
//  CE_NBRateDynamicsXMLParcerDelegate.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CENBRateDynamicsXMLParcerDelegate : NSObject<NSXMLParserDelegate>

-(NSMutableArray *)results;

@end
