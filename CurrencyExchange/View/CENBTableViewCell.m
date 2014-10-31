//
//  CE_NBTableViewCell.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENBTableViewCell.h"

@interface CENBTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deltaLabel;


@end

@implementation CENBTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCurrency:(CECurrencyNationalBank *)currency{
    if (_currency != currency){
        self.descriptionLabel.text = currency.quotName;
        self.codeLabel.text = currency.charCode;
        self.rateLabel.text = currency.rate;
        self.flagImage.image = [UIImage imageNamed:currency.charCode];
        
        self.code = currency.charCode;
        [self.deltaLabel setAttributedText:currency.aDelta];
    }

}

@end
