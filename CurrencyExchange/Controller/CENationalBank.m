//
//  CE_NationalBank.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENationalBank.h"
#import "CEMetalsRate.h"
#import "CECurrencyNationalBank.h"
#import "CENetWork.h"

#import "CECurrencyNationalBankParcer.h"
#import "CENBRateDynamics.h"
#import "CEMetalRateParcer.h"
#import "CERefinancingRateParcer.h"

#import "CEDate.h"
#import "CEEntityManager.h"


@interface CENationalBank()

@property (strong, atomic) NSMutableDictionary *currencyRate;
@property (strong, atomic) NSMutableDictionary *currencyRateTomorrow;

@property (strong, nonatomic) NSDictionary *displayedRate;

@property (strong, nonatomic) NSArray *todayCurrencyRate;
@property (strong, nonatomic) NSArray *tomorrowCurrencyRate;
@property (strong, nonatomic) NSArray *yesterdayCurrencyRate;

@property (strong, nonatomic) NSArray *monthCurrencyRate;
@property (strong, nonatomic) NSArray *beforeThisMonthRate;

@property (strong, nonatomic) CEMetalsRate *metalsRate;
@property (strong, nonatomic) NSString *refinancingRate;
@property (strong, atomic) CENetWork *network;
@property (atomic) BOOL updating;

@end

#define NOTIFICATION @"UPDATING_NB_DATA_COMPLETE"
#define NOTIFICATION_DYNAMIC @"DYNAMIC_RATE_LOAD"

#define TOTAL_UPDATE_REQUEST_COUNT 10

static int updateCounter;
static bool flagCurrencyRate;
static CENationalBank *instance;

@implementation CENationalBank


+(id)getInstance{
    
        static dispatch_once_t task;
        dispatch_once(&task, ^{
            instance = [[super alloc] init];
            if (instance){
                
                flagCurrencyRate = YES;
                
                instance.metalsRate = [[CEMetalsRate alloc] init];
                instance.refinancingRate = @"";
                
            [[NSNotificationCenter defaultCenter] addObserver:instance
                                                     selector:@selector(loadDataHandler:)
                                                         name:[CECurrencyNationalBankParcer notificationParcerName]
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:instance
                                                     selector:@selector(dynamicRateHandler:)
                                                         name:[CENBRateDynamics notificationParcerName]
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:instance
                                                     selector:@selector(loadDataHandler:)
                                                         name:[CEMetalRateParcer notificationParcerName]
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:instance
                                                     selector:@selector(loadDataHandler:)
                                                         name:[CERefinancingRateParcer notificationParcerName]
                                                       object:nil];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [instance update];
            });
           }
        });
    
    return instance;
}

-(NSDictionary *)currencyRateData{
    return _displayedRate;
}

-(void)swapCurrencyRate{
    if (flagCurrencyRate){
        self.displayedRate = self.currencyRateTomorrow;
        flagCurrencyRate = NO;
    } else {
        self.displayedRate = self.currencyRate;
        flagCurrencyRate = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DATA_UPDATE object:nil];
}

-(BOOL)isUpdating{
    return _updating;
}

-(void)update{

    updateCounter = TOTAL_UPDATE_REQUEST_COUNT; //complete control of all requests
    
    instance.updating = YES;
    
    instance.currencyRate = [[NSMutableDictionary alloc] init];
    instance.currencyRateTomorrow = [[NSMutableDictionary alloc] init];
    instance.yesterdayCurrencyRate = [[NSMutableArray alloc] init];
    
    instance.todayCurrencyRate = [[NSArray alloc] init];
    instance.tomorrowCurrencyRate = [[NSArray alloc] init];
    instance.yesterdayCurrencyRate = [[NSArray alloc] init];
    
    instance.monthCurrencyRate = [[NSArray alloc] init];
    instance.beforeThisMonthRate = [[NSArray alloc] init];
    
    
    
    instance.network = [[CENetWork alloc] init];
    
    CECurrencyNationalBankParcer *cnbpDay = [[CECurrencyNationalBankParcer alloc] initWithQueryMode:TodayMode];
    [instance.network downloadDataAndUseParcer:cnbpDay]; //request 1
   
    CERefinancingRateParcer *rrp = [[CERefinancingRateParcer alloc] init];
    [instance.network downloadDataAndUseParcer:rrp]; //request 2
    
    CEMetalRateParcer *mrp = [[CEMetalRateParcer alloc] initWithMetalID:instance.metalsRate.goldCode];
    [instance.network downloadDataAndUseParcer:mrp]; //request 3
    
}

-(void)dynamicRateHandler:(NSNotification *)notification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DYNAMIC object:notification.object];
}

-(void)loadDataHandler:(NSNotification *)notification{
    
    CEMetalRateParcer *mrp = nil;
    CECurrencyNationalBankParcer *cnbp = nil;
    
    if (notification.object){
        
        if ([notification.name isEqualToString:[CERefinancingRateParcer notificationParcerName]]){
            
            instance.refinancingRate = [(NSArray *)notification.object firstObject];
            updateCounter--;
            
        } else if ([notification.name isEqualToString:[CECurrencyNationalBankParcer notificationParcerName]]){
            cnbp= (CECurrencyNationalBankParcer *)notification.object;
            
            if (cnbp.mode == TodayMode){
                
                //handre today rate
                instance.todayCurrencyRate = cnbp.results;
                
                //create next request 4
                cnbp = [[CECurrencyNationalBankParcer alloc] initWithQueryMode:MonthMode];
                
            } else if (cnbp.mode == MonthMode){
                
                //handle this month rate
                
                instance.monthCurrencyRate = cnbp.results;
                
                //create next request 5
                cnbp = [[CECurrencyNationalBankParcer alloc] initWithQueryMode:YesterdayMode];

            } else if (cnbp.mode == YesterdayMode){
                
                //handle yesterday rate
                instance.yesterdayCurrencyRate = cnbp.results;
                
                //create next request 6
                cnbp = [[CECurrencyNationalBankParcer alloc] initWithQueryMode:BeforeMonth];
        
            } else if (cnbp.mode == BeforeMonth){
                
                //handle before month rate
                self.beforeThisMonthRate = cnbp.results;
                
                //create next request 7
                cnbp = [[CECurrencyNationalBankParcer alloc]initWithQueryMode:TomorrowMode];

            } else if (cnbp.mode == TomorrowMode){
                
                //handle tomorrow rate
                
                CECurrencyNationalBank *tomorrowObject = cnbp.results.firstObject;
                
                if (!([[CEDate toString:tomorrowObject.date] isEqualToString:[CEDate today]])){
                    self.tomorrowCurrencyRate = cnbp.results;
                } else {
                    self.tomorrowCurrencyRate = nil;
                }
                
                cnbp = nil;
                
                [self configureDictionary];
            }
            
            updateCounter--;
            
        } else if ([notification.name isEqualToString:[CEMetalRateParcer notificationParcerName]]){
            
            mrp = (CEMetalRateParcer *)notification.object;
            
            if ([mrp.metalID isEqualToString:instance.metalsRate.goldCode]){
                
                //handle gold rate
                instance.metalsRate.goldRate = mrp.results.lastObject;
                
                //create next request 8
                mrp = [[CEMetalRateParcer alloc] initWithMetalID:instance.metalsRate.silverCode];
                
                
            } else if ([mrp.metalID isEqualToString:instance.metalsRate.silverCode]){
                
                //handle silver rate
                instance.metalsRate.silverRate = mrp.results.lastObject;
                
                //create next request 9
                mrp = [[CEMetalRateParcer alloc] initWithMetalID:instance.metalsRate.platinumCode];
                
            } else if ([mrp.metalID isEqualToString:instance.metalsRate.platinumCode]){
                
                //handle platinum rate
                instance.metalsRate.platinumRate = mrp.results.lastObject;
                
                //create next request 10
                mrp = [[CEMetalRateParcer alloc] initWithMetalID:instance.metalsRate.palladiumCode];
                
            } else if ([mrp.metalID isEqualToString:instance.metalsRate.palladiumCode]){
                
                //handle palladium rate
                instance.metalsRate.palladiumRate = mrp.results.lastObject;
                mrp = nil;
                
            }
            
            updateCounter--;
        }
    }
    
    if (!(updateCounter) && (instance.updating)){
        instance.updating = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DATA_UPDATE object:nil];
        return;
    }
    
    if (mrp) [instance.network downloadDataAndUseParcer:mrp];
    if (cnbp) [instance.network downloadDataAndUseParcer:cnbp];
    
}

-(BOOL)configureDictionary{
    
    [self calculateDelta:self.todayCurrencyRate secondArray:self.yesterdayCurrencyRate];
    [self calculateDelta:self.monthCurrencyRate secondArray:self.beforeThisMonthRate];
    [self calculateDelta:self.tomorrowCurrencyRate secondArray:self.todayCurrencyRate];
    
    if (self.todayCurrencyRate.count)
        [self.currencyRate setValue:self.todayCurrencyRate forKey:NSLocalizedString(@" Updated daily", @"Обновляются ежедневно")];
    
    if (self.monthCurrencyRate.count)
        [self.currencyRate setValue:self.monthCurrencyRate forKey:NSLocalizedString(@"Updated monthly", @"Обновляются ежемесячно")];
    
    if (self.tomorrowCurrencyRate.count)
        [self.currencyRateTomorrow setValue:self.tomorrowCurrencyRate forKey:NSLocalizedString(@"Exchange Rates for tomorrow", @"Курсы валют на завтра")];
    
    
    //save objects in database
    CEEntityManager *manager = [[CEEntityManager alloc] init];
    [manager saveCurrencyNBObjects:self.todayCurrencyRate];
    
    
    if (self.todayCurrencyRate.count == 0){
        self.todayCurrencyRate = [manager loadObjects];
        [self.currencyRate setValue:self.todayCurrencyRate forKey:NSLocalizedString(@" Updated daily", @"Обновляются ежедневно")];
    }
    //////////////////////////
    
    
    if (flagCurrencyRate){
        self.displayedRate = self.currencyRate;
    } else {
        self.displayedRate = self.currencyRateTomorrow;
    }
    
    return YES;
}

-(BOOL)calculateDelta:(NSArray*)modifiedArray secondArray:(NSArray*)secondArray{
    
    for (int i = 0; i < modifiedArray.count; i++) {
        for (int j = 0; j < secondArray.count; j++){
            if ([((CECurrencyNationalBank *)modifiedArray[i]).currencyID isEqualToString:((CECurrencyNationalBank *)secondArray[j]).currencyID]){
                float todayRate = 0;
                float ydayRate = 0;
                todayRate = [((CECurrencyNationalBank *)modifiedArray[i]).rate floatValue];
                ydayRate = [((CECurrencyNationalBank *)secondArray[j]).rate floatValue];
                float result = todayRate - ydayRate;
                ((CECurrencyNationalBank *)modifiedArray[i]).delta = [NSString stringWithFormat:@"%f", result];
            }
        }
    }
    
    return YES;
}

-(void)rateDynamicForCurrency:(CECurrencyNationalBank *)currency{
  
    CENBRateDynamics *cnb = [[CENBRateDynamics alloc] init];
    
    [cnb rateDynamicForCurrency:currency];
    
    [instance.network downloadDataAndUseParcer:cnb];
    
}

-(NSArray *)allCurrencyRateTodayAndMonth{
    NSMutableArray *returnValue = [[NSMutableArray alloc] initWithArray:self.todayCurrencyRate];
    [returnValue addObjectsFromArray:self.monthCurrencyRate];
    
    return returnValue;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:instance];
}

@end
