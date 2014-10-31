//
//  CEConverterCell.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEConverterCell.h"

@interface CEConverterCell()

@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation CEConverterCell


-(void)setCurrency:(CECurrencyNationalBank *)currency{
    if (_currency != currency){
        _currency = currency;
        self.codeLabel.text = _currency.charCode;
        self.descriptionLabel.text = _currency.quotName;
        self.flagImage.image = [UIImage imageNamed:_currency.charCode];
    }
}

-(void)setSelectImage{
    self.checkImage.hidden = NO;
}

-(void)removeSelectImage{
    self.checkImage.hidden = YES;
}


@end
