//
//  CEConverterCell.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECurrencyNationalBank.h"

@interface CEConverterCell : UITableViewCell

@property (strong,nonatomic) CECurrencyNationalBank *currency;

-(void)setSelectImage;
-(void)removeSelectImage;

@end
