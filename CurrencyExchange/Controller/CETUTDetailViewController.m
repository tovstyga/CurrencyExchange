//
//  CETUTDetailViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTDetailViewController.h"
#import "CETUTbyManager.h"
#import "CETUTDetails.h"
#import "CETUTDetailsCurrencyRate.h"
#import "CEConverter.h"
#import "CEMapViewController.h"

@interface CETUTDetailViewController()

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) CETUTDetails *data;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *adressButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellLabel;

@end

@implementation CETUTDetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataHasBeenChangedNotiication:)
                                                     name:NOTIFICATION_DETAIL
                                                   object:nil];
        self.data = [[CETUTDetails alloc] init];
    }
    
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];

    [[CETUTbyManager getInstance] loadDetailInfoWithURL:self.currency.url];

    [self showAlert];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"mapSegue"]){
        CEMapViewController *controller = segue.destinationViewController;
        controller.currency = self.currency;
    
    } else {
    
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
        CEConverter *controller = segue.destinationViewController;
        controller.currency = self.data.currency[path.row];
    }
}

-(void)dataHasBeenChangedNotiication:(NSNotification *)notification{
    
    self.data = notification.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.titleLabel.text = self.data.title;
        self.subtitleLabel.text = self.data.subtitle;
        [self.adressButton setTitle:self.data.adress forState:UIControlStateNormal];
        
        NSString *text = @"";
        for (NSString *s in self.data.info){
            text = [text stringByAppendingString:s];
            text = [text stringByAppendingString:@"\n"];
        }
        
        
        
        [self.infoTextView setText:text];
        
        [self.tableView reloadData];
        
        [self closeAlert];
        
    });
    
    
}

-(void)showAlert{
    self.alert =[[UIAlertView alloc] initWithTitle:@"Loading Data" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *activity =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    [activity setFrame:CGRectMake(125, 60, 37, 37)];
    [self.alert addSubview:activity];
    [self.alert show];
}

-(void)closeAlert{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segmentControl.selectedSegmentIndex == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailServiceCell"forIndexPath:indexPath];
    
        cell.textLabel.text = self.data.services[indexPath.row];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCurrencyCell" forIndexPath:indexPath];
        
        CETUTDetailsCurrencyRate *cr = self.data.currency[indexPath.row];
        
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = cr.title;
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = cr.buy;
        
        label = (UILabel *)[cell viewWithTag:3];
        label.text = cr.sell;
        
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentControl.selectedSegmentIndex == 0){
        return self.data.services.count;
    } else {
        return self.data.currency.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (IBAction)showInMapAction:(UIButton *)sender {
}

- (IBAction)changeInfo:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex){
        self.bankLabel.hidden = NO;
        self.sellLabel.hidden = NO;
        self.buyLabel.hidden = NO;
    } else {
        self.bankLabel.hidden = YES;
        self.sellLabel.hidden = YES;
        self.buyLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}


@end
