//
//  CEMainTableVIewControllerTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/10/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEMainTableVIewControllerTableViewController.h"
#import "CENBTableViewCell.h"
#import "CENationalBank.h"
#import "CEMetalsRate.h"
#import "CESettings.h"
#import "CETUTTableViewController.h"
#import "CELockWindow.h"
#import "CEHistoryTableViewController.h"

@interface CEMainTableVIewControllerTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *favoriteCurrency;
@property (strong, nonatomic) NSArray *currencyKeys;
@property (strong, nonatomic) CENationalBank *bank;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverLabel;
@property (weak, nonatomic) IBOutlet UILabel *platinumLabel;
@property (weak, nonatomic) IBOutlet UILabel *palladiumLabel;
@property (strong, nonatomic) CELockWindow *lockView;
@property (weak, nonatomic) IBOutlet UILabel *refinancingLabel;

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) NSTimer *timer;

@end

#define kNAME_SETTINGS_FILE @"Settings"
#define kFAVORITE_CURRENCY_NAME @"FavoriteCurrency"

@implementation CEMainTableVIewControllerTableViewController

-(void)showAlert{
    self.alert =[[UIAlertView alloc] initWithTitle:@"Loading Data" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *activity =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    [activity setFrame:CGRectMake(125, 60, 37, 37)];
    [self.alert addSubview:activity];
    [self.alert show];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                  target:self
                                                selector:@selector(exceptionSituation)
                                                userInfo:nil
                                                 repeats:YES];
    
}

-(void)exceptionSituation{
    
    NSLog(@"Exception time out.");
    [self closeAlert];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                 message:@"Время загрузки данных истекло."
                                                delegate:self cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
    [al show];
    
  //  self.todayCurrencyRate = [manager loadObjects];
  //  [self.currencyRate setValue:self.todayCurrencyRate forKey:NSLocalizedString(@" Updated daily", @"Обновляются ежедневно")];
}

-(void)closeAlert{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(datasHasBeenChangedNotificationHandler:)
                                                 name:NOTIFICATION_DATA_UPDATE
                                               object:nil];
    
    self.bank = [CENationalBank getInstance];
    [self showAlert];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.destinationViewController isKindOfClass:[CETUTTableViewController class]]){
        CETUTTableViewController *controller = segue.destinationViewController;
        CENBTableViewCell *cell = sender;
    
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        controller.currency = self.favoriteCurrency[path.row];
    }
    if ([segue.identifier isEqualToString:@"history"]){
        CEHistoryTableViewController *controller = segue.destinationViewController;
        if (self.favoriteCurrency.count){
            controller.firstCurrency = self.favoriteCurrency[0];
            controller.secondCurrency = self.favoriteCurrency[1];
            controller.thirdCurrency = self.favoriteCurrency[2];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    CESettings *settings = [[CESettings alloc] init];
    
    self.currencyKeys = settings.favoriteCurrency;
    
    [self configureData];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.favoriteCurrency.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CENBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBCellMain" forIndexPath:indexPath];
    
    
    cell.currency = self.favoriteCurrency[indexPath.row];
   
    return cell;
}

-(void)datasHasBeenChangedNotificationHandler:(NSNotification *)notification{
   
    [self configureData];
    
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.refinancingLabel.text = [self.bank refinancingRate];
        self.goldLabel.text = [self.bank metalsRate].goldRate;
        self.silverLabel.text = [self.bank metalsRate].silverRate;
        self.platinumLabel.text = [self.bank metalsRate].platinumRate;
        self.palladiumLabel.text = [self.bank metalsRate].palladiumRate;
        [self closeAlert];
       //  [self.lockView closeWindow];
    });
    
}

-(void)configureData{
    NSString *sKey = [[[self.bank currencyRateData] allKeys] firstObject];
    NSArray *currencyList = [[self.bank currencyRateData] objectForKey:sKey];
    NSMutableArray *favoriteList = [[NSMutableArray alloc] init];
    
    for (CECurrencyNationalBank *c in currencyList){
        for (NSString *s in self.currencyKeys){
            if ([s isEqualToString:c.charCode]){
                [favoriteList addObject:c];
                break;
            }
        }
    }
    
    self.favoriteCurrency = favoriteList;
}
- (IBAction)refrashButtonClick:(UIBarButtonItem *)sender {
    //[self.lockView showWindowInFrame:self.view];
    [self showAlert];
    [self.bank update];
}

@end
