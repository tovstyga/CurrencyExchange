//
//  CEConverterSelectTableView.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECurrencyNationalBank.h"
#import "CENationalBank.h"

@interface CEConverterSelectTableView : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CECurrencyNationalBank *changedValue;

@end
