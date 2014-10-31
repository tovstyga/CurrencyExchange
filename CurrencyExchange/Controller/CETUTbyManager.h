//
//  CE_TUTLinkManager.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEBank.h"
#import "CECurrencyNationalBank.h"

#define NOTIFICATION_MAIN @"NOTIFICATION_TUT_UPDATE"
#define NOTIFICATION_DETAIL @"NOTIFICATION_DETAIL"


@interface CETUTbyManager : NSObject

+(instancetype)getInstance;

-(void)swapData;
-(NSArray *)data;
-(void)performRequestForRegion:(NSString *)region currency:(CECurrencyNationalBank *)currency bank:(CEBank *)bank;
-(void)nextPage;
-(BOOL)hasNext;

-(void)loadDetailInfoWithURL:(NSURL *)url;

@end
