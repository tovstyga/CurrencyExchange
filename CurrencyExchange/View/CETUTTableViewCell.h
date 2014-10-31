//
//  CE_TUTTableViewCell.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CETUTbyCurrency.h"

@interface CETUTTableViewCell : UITableViewCell

-(void)configureCell:(CETUTbyCurrency *)currency;

@end
