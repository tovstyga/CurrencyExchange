//
//  CEConverter.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEConverter.h"

@interface CEConverter()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *fieldFirst;
@property (weak, nonatomic) IBOutlet UITextField *fieldLast;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

@property (nonatomic) float sellRate;
@property (nonatomic) float buyRate;

@end

@implementation CEConverter

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.currencyNameLabel.text = self.currency.title;
    
    self.sellRate = [[self.currency.sell stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
    self.buyRate = [[self.currency.buy stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
    
}

- (IBAction)valueChangedFirstField:(UITextField *)sender {
    
    float value = [self.fieldFirst.text floatValue];
    
    if (self.segmentControl.selectedSegmentIndex){
        value = value/self.buyRate;
    } else {
        value = value/self.sellRate;
    }
    self.fieldLast.text = [NSString stringWithFormat:@"%f", value];
}

- (IBAction)valueChangedLastField:(UITextField *)sender {
    float value = [self.fieldLast.text floatValue];
    
    if (self.segmentControl.selectedSegmentIndex){
        value = value*self.buyRate;
    } else {
        value = value*self.sellRate;
    }
    self.fieldFirst.text = [NSString stringWithFormat:@"%f", value];
}

- (IBAction)segmintchanged:(id)sender {
    [self valueChangedLastField:nil];
}

@end
