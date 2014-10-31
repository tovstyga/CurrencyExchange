//
//  CE_TUTTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTTableViewController.h"
#import "CENetWork.h"
#import "CETUTbyCurrency.h"
#import "CETUTParcer.h"
#import "CETUTTableViewCell.h"
#import "CETUTbyManager.h"
#import "AppDelegate.h"
#import "CELockWindow.h"
#import "CESettings.h"
#import "CETUTDetailViewController.h"


@interface CETUTTableViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *activity;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) CETUTbyManager *manager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleButton;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) CELockWindow *lockView;

@end

static BOOL buyDisplayed;

@implementation CETUTTableViewController
- (IBAction)rightBarButtonClick:(UIBarButtonItem *)sender {
    
    if (buyDisplayed){
        buyDisplayed = NO;
        self.toggleButton.title = NSLocalizedString(@"Buy", @"Купить");
    } else {
        buyDisplayed = YES;
        self.toggleButton.title = NSLocalizedString(@"Sell", @"Продать");
    }
    [self.manager swapData];
}

-(void)refreshTable{
   
    CESettings *settings = [[CESettings alloc] init];
    
    [self.manager performRequestForRegion:settings.location currency:self.currency bank:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lockView = [[CELockWindow alloc] init];
    
    NSString *title = [NSString stringWithFormat:@"%@ (%@)", self.currency.charCode, self.currency.rate];
    
    self.title = title;
    
    buyDisplayed = YES;
    self.toggleButton.title = NSLocalizedString(@"Sell", @"Продать");
    
    self.manager = [CETUTbyManager getInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSourceCurrencyIsChanged:)
                                                 name:NOTIFICATION_MAIN
                                               object:nil];
    CESettings *settings = [[CESettings alloc] init];
    
    [self.manager performRequestForRegion:settings.location currency:self.currency bank:nil];
    
    self.refresh = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refresh];
    [self.refresh addTarget:self
                     action:@selector(refreshTable)
           forControlEvents:UIControlEventValueChanged];
   
    self.tableView.scrollEnabled = NO;
    [self.lockView showWindowInFrame:self.view];
}


-(void)dataSourceCurrencyIsChanged:(NSNotification *)notification{

        self.data = self.manager.data;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            [self.lockView closeWindow];
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
            [self.refresh endRefreshing];
        });
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CETUTTableViewCell *cell = (CETUTTableViewCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    CETUTDetailViewController *controller = segue.destinationViewController;
    controller.currency = self.data[path.row];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([self.manager hasNext]){
        return [self.data count]+1;
    } else {
        return [self.data count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.data.count){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.imageView.image = nil;
        cell.textLabel.text = NSLocalizedString(@"Load more...", @"load more");

        
        return cell;
    } else {
        CETUTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUTCell" forIndexPath:indexPath];
        cell.textLabel.text = nil;
        [cell configureCell:self.data[indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (([[cell reuseIdentifier] isEqualToString:@"cell"]) && !([self.activity isAnimating])){
        cell.textLabel.text = @"";
        if ([self.manager hasNext]){
            [self.manager nextPage];
            
            
            CGRect frame = cell.frame;
            self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activity.center = CGPointMake(frame.size.width/2, frame.size.height/2);
            [cell addSubview:self.activity];
            [self.activity startAnimating];

        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 70, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 70, 18)];
    [buyLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [buyLabel setText:NSLocalizedString(@"Buy", @"Купить")];
    
    UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 70, 18)];
    [sellLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [sellLabel setText:NSLocalizedString(@"Sell", @"Продать")];
    
    if (buyDisplayed){
        buyLabel.textColor = [UIColor whiteColor];
        sellLabel.textColor = [UIColor blackColor];
    } else {
        buyLabel.textColor = [UIColor blackColor];
        sellLabel.textColor = [UIColor whiteColor];
    }
    
    [view addSubview:sellLabel];
    [view addSubview:buyLabel];
    
    [label setText:NSLocalizedString(@"BANK", @"БАНК")];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}


@end
