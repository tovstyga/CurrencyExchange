//
//  CESettingsFavoriteTableViewController.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/10/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CESettingsFavoriteTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) NSString *selectedFieldName;

@end
