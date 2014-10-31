//
//  CE_MetalsRate.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEMetalsRate.h"

#define kGOLD @"gold"
#define kSILVER @"silver"
#define kPLATINUM @"platinum"
#define kPALLADIUM @"palladium"

#define kCode @"Code"
#define kNAME_BEL @"NameBel"
#define kNAME_RU @"NameRu"
#define kNAME_ENG @"NameEng"

#define kMETALS_PLIST_NAME @"MetalsPropertyList"

@implementation CEMetalsRate

-(id)init{
    self = [super init];
    if (self){
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMETALS_PLIST_NAME ofType:@"plist"]];
        
        NSDictionary *temp = [dict objectForKey:kGOLD];
        _goldCode = [temp objectForKey:kCode];
        _goldName = [temp objectForKey:kNAME_ENG];
        
        temp = [dict objectForKey:kSILVER];
        _silverCode = [temp objectForKey:kCode];
        _silverName = [temp objectForKey:kNAME_ENG];
        
        temp = [dict objectForKey:kPLATINUM];
        _platinumCode = [temp objectForKey:kCode];
        _platinumName = [temp objectForKey:kNAME_ENG];
        
        temp = [dict objectForKey:kPALLADIUM];
        _palladiumCode = [temp objectForKey:kCode];
        _palladiumName = [temp objectForKey:kNAME_ENG];
    }
    return self;
}

@end
