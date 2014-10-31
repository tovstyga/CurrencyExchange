//
//  CE_MetalsRate.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEMetalsRate : NSObject

@property (strong, nonatomic) NSString *goldName;
@property (strong, nonatomic) NSString *goldCode;
@property (strong, nonatomic) NSString *goldRate;

@property (strong, nonatomic) NSString *silverName;
@property (strong, nonatomic) NSString *silverCode;
@property (strong, nonatomic) NSString *silverRate;

@property (strong, nonatomic) NSString *platinumName;
@property (strong, nonatomic) NSString *platinumCode;
@property (strong, nonatomic) NSString *platinumRate;

@property (strong, nonatomic) NSString *palladiumName;
@property (strong, nonatomic) NSString *palladiumCode;
@property (strong, nonatomic) NSString *palladiumRate;

@end
