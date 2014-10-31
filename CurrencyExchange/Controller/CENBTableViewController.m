//
//  CE_NBTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENBTableViewController.h"
#import "CENationalBank.h"
#import "CENBTableViewCell.h"
#import "AppDelegate.h"

#import "CETUTParametrs.h"
#import "CETUTParcer.h"
#import "CENetWork.h"

#import "CETUTTableViewController.h"


@interface CENBTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleBarButton;

@property (strong, nonatomic) UIRefreshControl *refresh;

@property (strong, nonatomic) CENationalBank *bank;
@property (strong, nonatomic) NSArray *sectionNames;


@end

@implementation CENBTableViewController

static bool tomorrow;
#pragma mark actions
- (IBAction)rightBarBTNClick:(UIBarButtonItem *)sender {
    if (tomorrow){
        tomorrow = NO;
        self.toggleBarButton.title = NSLocalizedString(@"Tomorrow",  @"Завтра");
        [self.bank swapCurrencyRate];
    } else {
        tomorrow = YES;
        self.toggleBarButton.title = NSLocalizedString(@"Today", @"Сегодня");
        [self.bank swapCurrencyRate];
    }
}

-(void)refreshTable{
    [self.bank update];
}


#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    tomorrow = NO;
    
    
    self.toggleBarButton.title = NSLocalizedString(@"Tomorrow",  @"Завтра");
    
    self.refresh = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refresh];
    [self.refresh addTarget:self
                     action:@selector(refreshTable)
           forControlEvents:UIControlEventValueChanged];

    
    self.bank = [CENationalBank getInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSourceIsChanged:)
                                                 name:NOTIFICATION_DATA_UPDATE
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CETUTTableViewController *controller = segue.destinationViewController;
    CENBTableViewCell *cell = sender;
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    NSString *objectKey = self.sectionNames[path.section];
    NSArray *sectionValues = (NSArray *)[[self.bank currencyRateData] objectForKey:objectKey];
    CECurrencyNationalBank *object = (CECurrencyNationalBank *)sectionValues[path.row];
    
    controller.currency = object;
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    BOOL result = YES;
    
    if ([identifier isEqualToString:@"pushTUTCurrency"]){
        CENBTableViewCell *cell = (CENBTableViewCell *)sender;
        CETUTParametrs *param = [[CETUTParametrs alloc] init];
        
        if ([param.currencyList objectForKey:cell.code]){
            
        } else {
            result = NO;
        }
    }
    return result;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    self.sectionNames = [self.bank currencyRateData].allKeys;
    
    if (self.sectionNames.count > 1){
        
        tomorrow = NO;
        self.toggleBarButton.title = NSLocalizedString(@"Tomorrow",  @"Завтра");
    } else {
        
        tomorrow = YES;
        self.toggleBarButton.title = NSLocalizedString(@"Today",  @"Сегодня");
    }
    
    return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return ((NSArray *)[[self.bank currencyRateData] objectForKey:(self.sectionNames[section])]).count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CENBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBCell" forIndexPath:indexPath];
    
    NSString *objectKey = self.sectionNames[indexPath.section];
    NSArray *sectionValues = (NSArray *)[[self.bank currencyRateData] objectForKey:objectKey];
    cell.currency = (CECurrencyNationalBank *)sectionValues[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];

    
    [label setText:(NSString *)self.sectionNames[section]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

-(void)dataSourceIsChanged:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.refresh endRefreshing];
    });
    
}

@end
