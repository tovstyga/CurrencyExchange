//
//  CEHistoryTableViewController.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEHistoryTableViewController.h"
#import "CENationalBank.h"
#import "CEDate.h"
#import "CELoadingView.h"

@interface CEHistoryTableViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageGraph;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sectionSegment;


@property (strong, nonatomic) NSDictionary *dynamicFirstCurrency;
@property (strong, nonatomic) NSDictionary *dynamicSecondCurrency;
@property (strong, nonatomic) NSDictionary *dynamicThirdCurrency;

@property (strong, nonatomic) UIImage *dynamicFirstImage;
@property (strong, nonatomic) UIImage *dynamicSecondImage;
@property (strong, nonatomic) UIImage *dynamicThirdImage;


@property (strong, nonatomic) NSMutableArray *keys;
@property (strong, nonatomic) NSDictionary *workDictionary;
@property (strong, nonatomic) CECurrencyNationalBank *template;

@property (strong, nonatomic) NSDateFormatter *formatter;

@property (nonatomic) float min;
@property (nonatomic) float max;
@property (nonatomic) float startY;
@property (nonatomic) double coef;

@property (strong, nonatomic) NSMutableArray *delta;

@property (strong, nonatomic) UIAlertView *alert;

@end

#define kDATE_FORMAT_FOR_DISPLAY @"dd-MM-YYYY"

@implementation CEHistoryTableViewController 

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.workDictionary = [[NSDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateContent:)
                                                 name:NOTIFICATION_DYNAMIC
                                               object:nil];
    
    self.template = self.firstCurrency;
    [[CENationalBank getInstance] rateDynamicForCurrency:self.firstCurrency];
    
    [self.sectionSegment addTarget:self
                         action:@selector(segmentChange)
               forControlEvents:UIControlEventValueChanged];
    [self.sectionSegment setTitle:self.firstCurrency.charCode forSegmentAtIndex:0];
    [self.sectionSegment setTitle:self.secondCurrency.charCode forSegmentAtIndex:1];
    [self.sectionSegment setTitle:self.thirdCurrency.charCode forSegmentAtIndex:2];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:kDATE_FORMAT_FOR_DISPLAY];
    
    self.title = self.firstCurrency.charCode;
    
    
    [self showAlert];
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

-(BOOL)configGraph{
   
    UIImage *image = [UIImage imageNamed:@"white_big"];
    
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    
    CGContextMoveToPoint(context, 0, self.startY);
    
    float xPoint = 1;
    float yPoint = self.startY;
    
    for (NSNumber *numb in self.delta){
        
        CGContextAddLineToPoint(context, xPoint, (yPoint + [numb floatValue]));
        
      //  NSLog(@"x=%f y=%f", xPoint, yPoint+[numb floatValue]);
        xPoint++;
        yPoint = yPoint + [numb floatValue];
    
    }
    
    CGContextStrokePath(context);
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (self.template == self.firstCurrency){
        self.dynamicFirstImage = retImage;
    } else if (self.template == self.secondCurrency){
        self.dynamicSecondImage = retImage;
    } else if (self.template == self.thirdCurrency){
        self.dynamicThirdImage = retImage;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageGraph setImage:retImage];
    });
    
    UIGraphicsEndImageContext();
    
    return YES;
}

-(BOOL)configureDeltaArray{
    
    self.min = MAXFLOAT;
    self.max = 0;
    self.delta = [[NSMutableArray alloc] init];
    
    for (NSDate *d in self.keys){
        
        float f = [[self.workDictionary objectForKey:d] floatValue];
        if (f >= self.max){
            self.max = f;
        }
        if (f <= self.min){
            self.min = f;
        }
    }
    
    self.coef = (self.max - self.min)/self.imageGraph.bounds.size.height;
    
    self.delta = [[NSMutableArray alloc] init];
    
    float temp = 0;
    for (NSDate *d in self.keys){
        
        if (!temp){
            temp = [[self.workDictionary objectForKey:[self.keys firstObject]] floatValue];
            self.startY = self.imageGraph.bounds.size.height + (self.min - temp)/self.coef;
            continue;
        }
        
        float f = [[self.workDictionary objectForKey:d] floatValue];
        
        NSNumber *delta = [[NSNumber alloc] initWithFloat:(temp - f)/self.coef];
        temp = f;
        [self.delta addObject:delta];
       
    }

   
    
    return YES;
}

-(void)segmentChange{
    
   // [self.imageGraph setImage:[UIImage imageNamed:@"white_big"]];
    
    switch (self.sectionSegment.selectedSegmentIndex) {
        case 0:
            if (self.dynamicFirstCurrency){
                self.workDictionary = self.dynamicFirstCurrency;
                [self.imageGraph setImage:self.dynamicFirstImage];
            } else {
                self.template = self.firstCurrency;
                [[CENationalBank getInstance] rateDynamicForCurrency:self.firstCurrency];
                [self showAlert];
            }
            self.title = self.firstCurrency.charCode;
            break;
        case 1:
            if (self.dynamicSecondCurrency){
                self.workDictionary = self.dynamicSecondCurrency;
                [self.imageGraph setImage:self.dynamicSecondImage];
            } else {
                self.template = self.secondCurrency;
                [[CENationalBank getInstance] rateDynamicForCurrency:self.secondCurrency];
                [self showAlert];
            }
            self.title = self.secondCurrency.charCode;
            break;
        case 2:
            if (self.dynamicThirdCurrency){
                self.workDictionary = self.dynamicThirdCurrency;
                [self.imageGraph setImage:self.dynamicThirdImage];
            } else {
                self.template = self.thirdCurrency;
                [[CENationalBank getInstance] rateDynamicForCurrency:self.thirdCurrency];
                [self showAlert];
            }
            self.title = self.thirdCurrency.charCode;
            break;
        default:
            break;
    }

    [self.tableView reloadData];
}

-(void)updateContent:(NSNotification *)notification{
    
    if (self.template == self.firstCurrency){
        self.dynamicFirstCurrency = notification.object;
        self.workDictionary = self.dynamicFirstCurrency;
    } else if (self.template == self.secondCurrency){
        self.dynamicSecondCurrency = notification.object;
        self.workDictionary = self.dynamicSecondCurrency;
    } else if (self.template == self.thirdCurrency){
        self.dynamicThirdCurrency = notification.object;
        self.workDictionary = self.dynamicThirdCurrency;
    }
    
    if (!self.keys){
        self.keys = [[NSMutableArray alloc] initWithArray:[self.workDictionary allKeys]];
        
        [self.keys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSDate *date1 = (NSDate *)obj1;
            NSDate *date2 = (NSDate *)obj2;
            
            return [date1 compare:date2];
        }];
        
    }
    
    [self configureDeltaArray];
    [self configGraph];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self closeAlert];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.keys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    cell.textLabel.text = [self.formatter stringFromDate:[self.keys objectAtIndex:indexPath.row]];
    
    NSNumber *numb = [self.workDictionary objectForKey:[self.keys objectAtIndex:indexPath.row]];
    
    NSString *tmp = [NSString stringWithFormat:@"%1.2f", [numb floatValue]];
    cell.detailTextLabel.text = tmp;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
