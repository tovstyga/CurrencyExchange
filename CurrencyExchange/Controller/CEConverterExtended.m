//
//  CEConverterExtended.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEConverterExtended.h"
#import "CENationalBank.h"
#import "CECurrencyNationalBank.h"
#import "CEBelRub.h"
#import "CEConverterSelectTableView.h"
#import "CESettings.h"

@interface CEConverterExtended()

@property (weak, nonatomic) IBOutlet UIImageView *firstFlag;
@property (weak, nonatomic) IBOutlet UILabel *firstCurrencyName;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIImageView *secondFlag;
@property (weak, nonatomic) IBOutlet UILabel *secondCurrencyName;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (strong, nonatomic) CECurrencyNationalBank *firstCurrency;
@property (strong, nonatomic) CECurrencyNationalBank *secondCurrency;

@end


@implementation CEConverterExtended

static float firstRate;
static float secondRate;

static float coeficient;

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];

    if (self){
    
    }
    
    return self;
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    CESettings *settings = [[CESettings alloc] init];
    
    self.firstCurrency = nil;
    self.secondCurrency =nil;
    
    for (CECurrencyNationalBank * cur in [[CENationalBank getInstance] allCurrencyRateTodayAndMonth]){
        if ([cur.charCode isEqualToString:settings.convertCurrency[0]]){
            self.firstCurrency = cur;
        } else if ([cur.charCode isEqualToString:settings.convertCurrency[1]]){
            self.secondCurrency = cur;
        }
    }
   
    if (!self.firstCurrency){
        self.firstCurrency = [CEBelRub defaultCurrency];
    } else if (!self.secondCurrency){
        self.secondCurrency = [CEBelRub defaultCurrency];
    }
    
    self.firstFlag.image = [UIImage imageNamed:self.firstCurrency.charCode];
    self.firstCurrencyName.text = self.firstCurrency.quotName;
    
    self.secondFlag.image = [UIImage imageNamed:self.secondCurrency.charCode];
    self.secondCurrencyName.text = self.secondCurrency.quotName;
    
    firstRate = [self.firstCurrency.rate floatValue];
    secondRate = [self.secondCurrency.rate floatValue];
    
    self.firstTextField.text = @"";
    self.secondTextField.text = @"";
    
    coeficient = firstRate/secondRate;
    
}

- (IBAction)firstValueChanged:(UITextField *)sender {
    float value = [sender.text floatValue];
    secondRate = value*coeficient;
    self.secondTextField.text = [NSString stringWithFormat:@"%f", secondRate];
}

- (IBAction)secondValueChanged:(UITextField *)sender {
    float value = [sender.text floatValue];
    firstRate = value/coeficient;
    self.firstTextField.text = [NSString stringWithFormat:@"%f", firstRate];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CEConverterSelectTableView *controller = segue.destinationViewController;
    if (sender == self.firstButton){
        controller.changedValue = self.firstCurrency;
    } else {
        controller.changedValue = self.secondCurrency;
    }
    
}


@end
