//
//  CESettingsFavoriteView.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/10/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CESettingsFavoriteViewController.h"
#import "CESettingsFavoriteTableViewController.h"
#import "CESettings.h"
#import "CESettingsFavoriteTableViewCell.h"

@interface CESettingsFavoriteViewController()

@property (strong, nonatomic) NSArray *currencyKeys;

@end

@implementation CESettingsFavoriteViewController

#define kNAME_SETTINGS_FILE @"Settings"
#define kFAVORITE_CURRENCY_NAME @"FavoriteCurrency"


#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ((CESettingsFavoriteTableViewController *)segue.destinationViewController).selectedFieldName = ((CESettingsFavoriteTableViewCell *)sender).currencyNameLabel.text;
    
}

-(void)viewWillAppear:(BOOL)animated{

    CESettings *settings = [[CESettings alloc] init];

    self.currencyKeys = settings.favoriteCurrency;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.currencyKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CESettingsFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsFavoriteCell" forIndexPath:indexPath];
    
    cell.currencyNameLabel.text = self.currencyKeys[indexPath.row];
    cell.flagImageView.image = [UIImage imageNamed:self.currencyKeys[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
