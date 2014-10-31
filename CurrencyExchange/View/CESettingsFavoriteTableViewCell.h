//
//  CESettingsFavoriteTableViewCell.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/10/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CESettingsFavoriteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chekedImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

@end
