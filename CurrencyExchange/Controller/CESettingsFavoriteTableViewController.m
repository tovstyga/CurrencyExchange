//
//  CESettingsFavoriteTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/10/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CESettingsFavoriteTableViewController.h"
#import "CESettingsFavoriteTableViewCell.h"
#import "CESettings.h"

@interface CESettingsFavoriteTableViewController ()


@property (strong, nonatomic) CESettings *settings;
@property (strong, nonatomic) NSMutableArray *keys;
@property (strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) NSString *dublicateSelectedItemName;

@end

#define kNAME_SETTINGS_FILE @"Settings"
#define kFAVORITE_CURRENCY_NAME @"FavoriteCurrency"
#define kTUTBY_PLIST_NAME @"TutbyFinancePropertyList"
#define kCURRENCY_KEY @"Currency"

@implementation CESettingsFavoriteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.settings = [[CESettings alloc] init];
    
    self.dublicateSelectedItemName = [self.selectedFieldName copy];
    
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kTUTBY_PLIST_NAME ofType:@"plist"]];
    
    self.keys = [[NSMutableArray alloc] initWithArray:[[root objectForKey:kCURRENCY_KEY] allKeys]];
    
    for (NSString *s in self.settings.favoriteCurrency){
        for (NSString *st in self.keys){
            if ([s isEqualToString:st] && ![st isEqualToString:self.selectedFieldName]){
                [self.keys removeObject:st];
                break;
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
   
    
    for (NSString *s in self.settings.favoriteCurrency){
        if ([self.dublicateSelectedItemName isEqualToString:s]){
            [self.settings.favoriteCurrency removeObject:s];
            break;
        }
    }
    
    [self.settings.favoriteCurrency addObject:self.selectedFieldName];
    
    [self.settings save];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.keys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CESettingsFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsFavorite" forIndexPath:indexPath];
    
    cell.currencyNameLabel.text = self.keys[indexPath.row];
    cell.flagImageView.image = [UIImage imageNamed:self.keys[indexPath.row]];
    cell.chekedImageView.hidden = YES;
    
    if ([(NSString *)self.keys[indexPath.row] isEqualToString:self.selectedFieldName]){
        cell.chekedImageView.hidden =NO;
        self.path = indexPath;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath == self.path) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    self.selectedFieldName = self.keys[indexPath.row];
  
    [tableView reloadData];
    
}


@end
