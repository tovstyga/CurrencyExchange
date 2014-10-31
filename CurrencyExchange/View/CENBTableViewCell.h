//
//  CE_NBTableViewCell.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECurrencyNationalBank.h"

@interface CENBTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *code;

@property (weak, nonatomic) CECurrencyNationalBank *currency;


@end
