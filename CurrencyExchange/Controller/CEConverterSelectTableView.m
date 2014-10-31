//
//  CEConverterSelectTableView.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEConverterSelectTableView.h"
#import "CEConverterCell.h"
#import "CEBelRub.h"
#import "CESettings.h"

@interface CEConverterSelectTableView()

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *removeKey;

@end

@implementation CEConverterSelectTableView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //self.currency = self.changeCurrencyDelegate;
    
    self.data = [[NSMutableArray alloc] init];
    [self.data addObject:[CEBelRub defaultCurrency]];
    [self.data addObjectsFromArray:[[CENationalBank getInstance] allCurrencyRateTodayAndMonth]];
    self.removeKey = self.changedValue.charCode;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (![self.changedValue.charCode isEqualToString:self.removeKey]){
        CESettings *settings = [[CESettings alloc] init];
        if ([settings.convertCurrency[0] isEqualToString:self.removeKey]){
            [settings.convertCurrency removeObjectAtIndex:0];
            [settings.convertCurrency insertObject:self.changedValue.charCode atIndex:0];
        } else {
            [settings.convertCurrency removeObjectAtIndex:1];
            [settings.convertCurrency insertObject:self.changedValue.charCode atIndex:1];
        }
        
        [settings save];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CEConverterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConverterCell" forIndexPath:indexPath];
    
    cell.currency = (CECurrencyNationalBank *)self.data[indexPath.row];
    
    if ([((CECurrencyNationalBank *)self.data[indexPath.row]).charCode isEqualToString:self.changedValue.charCode]){
        [cell setSelectImage];
    } else {
        [cell removeSelectImage];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.changedValue = self.data[indexPath.row];
    [tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

@end
