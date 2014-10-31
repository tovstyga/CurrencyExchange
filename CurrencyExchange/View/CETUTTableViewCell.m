//
//  CE_TUTTableViewCell.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTTableViewCell.h"

@interface CETUTTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *deportamentName;
@property (weak, nonatomic) IBOutlet UILabel *buy;
@property (weak, nonatomic) IBOutlet UILabel *sell;

@end

@implementation CETUTTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(CETUTbyCurrency *)currency{
    self.bankName.text = currency.bankName;
    self.deportamentName.text = currency.departamentName;
    self.buy.text = currency.buyRate;
    self.sell.text = currency.sellRate;
    
    NSString *text = currency.url.description;
    NSArray *array = [text componentsSeparatedByString:@"/"];
    
    //4 index element in url
    [self.bankLogoImage setImage:[UIImage imageNamed:array[4]]];
    
}
@end
