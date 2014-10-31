//
//  CEHistoryTableViewController.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CECurrencyNationalBank.h"

@interface CEHistoryTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CECurrencyNationalBank *firstCurrency;
@property (strong, nonatomic) CECurrencyNationalBank *secondCurrency;
@property (strong, nonatomic) CECurrencyNationalBank *thirdCurrency;

@end
