//
//  CESettingsLocationTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/13/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CESettingsLocationTableViewController.h"
#import "CESettings.h"

@interface CESettingsLocationTableViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) CESettings *settings;
@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSArray *defaultKeys;

@end

#define kTUTBY_PLIST_NAME @"TutbyFinancePropertyList"
#define kREGION_NAMES_KEY @"RegionsRU"

@implementation CESettingsLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kTUTBY_PLIST_NAME ofType:@"plist"]];
    
    self.settings = [[CESettings alloc] init];
    
    self.data = [root objectForKey:kREGION_NAMES_KEY];
    self.keys = [self.data allKeys];
    self.defaultKeys = [self.data allKeys];
    
    self.title = [self.data objectForKey:self.settings.location];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.settings save];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.keys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.data objectForKey:[self.keys objectAtIndex:indexPath.row]];
    
    if ([self.keys[indexPath.row] isEqualToString:self.settings.location]){
        cell.imageView.image = [UIImage imageNamed:@"check"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"white"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.settings.location = self.keys[indexPath.row];
    self.title = [self.data objectForKey:self.settings.location];

    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    
    
}

#pragma mark UISearchBar Delegate methods

-(void)handlesearchForTerm:(NSString *)term{
    
    self.keys = [self.data allKeys];
    
    NSMutableArray *tempKeys = [[NSMutableArray alloc] init];
    
    for (NSString *s in self.keys){
        if ([[self.data objectForKey:s] rangeOfString:term options:NSCaseInsensitiveSearch].location != NSNotFound){
            [tempKeys addObject:s];
        }
    }
    
    self.keys = tempKeys;
    [self.tableView reloadData];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *searchTerm = searchBar.text;
    [self handlesearchForTerm:searchTerm];
    [searchBar resignFirstResponder];
    
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0){
        self.keys = [self.data allKeys];
        [self.tableView reloadData];
    } else {
        [self handlesearchForTerm:searchText];
    }
}


@end
