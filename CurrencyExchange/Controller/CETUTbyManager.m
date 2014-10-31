//
//  CE_TUTLinkManager.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTbyManager.h"
#import "CECurrencyNationalBank.h"
#import "CEBank.h"
#import "CETUTParcer.h"
#import "CETUTParametrs.h"
#import "CENetWork.h"
#import "CETUTParcerDetail.h"
#import "CETUTDetails.h"

@interface CETUTbyManager()

@property(strong, nonatomic) NSArray *bankSortSell;
@property(strong, nonatomic) NSArray *bankSortBuy;

@property(strong, nonatomic) NSArray *backupSortSell;
@property(strong, nonatomic) NSArray *backupSortBuy;

@property(strong, nonatomic) NSArray *displayData;

@property(strong, nonatomic) CETUTParametrs *param;
@property(strong, nonatomic) CENetWork *network;

@property(strong, nonatomic) NSString *urlStringForRequest;

@property(strong, nonatomic) NSURL *urlForDetail;
@property(strong, nonatomic) CETUTDetails *details;


@end


#define kMAIN_LINK @"http://finance.tut.by/kurs/%@/%@"
#define kSORT_BY_SELL @"?sortBy=sell"
#define kSORT_BY_BUY @"?sortBy=buy&sortDir=down"
#define kPAGE_NUMB @"&iPageNo=%i"

#define NOTIFICATION_MAIN @"NOTIFICATION_TUT_UPDATE"
#define NOTIFICATION_DETAIL @"NOTIFICATION_DETAIL"

static CETUTbyManager *instance;
static BOOL sellDisplay;
static int page;
static BOOL hasNext;

@implementation CETUTbyManager

-(NSArray *)data{
    return instance.displayData;
}

-(void)swapData{
    if (sellDisplay){
        sellDisplay = NO;
        instance.displayData = instance.bankSortBuy;
    } else {
        sellDisplay = YES;
        instance.displayData = instance.bankSortSell;
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAIN object:nil];

}

+(instancetype)getInstance{
    static dispatch_once_t t;
        dispatch_once(&t, ^{
            instance = [[super alloc] init];
            if (instance){
                sellDisplay = YES;
                
                instance.bankSortBuy = [[NSArray alloc] init];
                instance.bankSortSell = [[NSArray alloc] init];
                instance.urlStringForRequest = nil;
                
                instance.network = [[CENetWork alloc] init];
                
                instance.param = [[CETUTParametrs alloc] init];
                
                [[NSNotificationCenter defaultCenter] addObserver:instance
                                                         selector:@selector(loadDataHandler:)
                                                             name:[CETUTParcer notificationParcerName]
                                                           object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:instance
                                                         selector:@selector(detailDataLoadNotificationHandler:)
                                                             name:[CETUTParcerDetail notificationParcerName]
                                                           object:nil];
            }
        });
    
    return instance;
}

-(void)performRequestForRegion:(NSString *)region currency:(CECurrencyNationalBank *)currency bank:(CEBank *)bank{
    
    page = 1;
    
    instance.backupSortBuy = nil;
    instance.backupSortSell = nil;
    
    BOOL correct = NO;
    NSString *urlString;
    if ((region) && ([instance.param.regionsList objectForKey:region])){
        if (currency){
             NSString *cur = [instance.param.currencyList objectForKey:currency.charCode];
            urlString = [NSString stringWithFormat:kMAIN_LINK, region, cur];
            if (bank){
                for (NSString *s in bank.currency){
                    if ([s isEqualToString:cur]){
                        for (NSString *st in bank.region){
                            
                            if ([st isEqualToString:region]){
                                
                                NSString *tmp = [NSString stringWithFormat:@"/%@", bank.key];
                                urlString = [urlString stringByAppendingString:tmp];
                                correct = YES;
                            }
                            if (correct) {
                                break;
                            }
                        }
                    }
                    if (correct) {
                        break;
                    }
                }
                if (!correct) {
                    return;
                }
            }

        } else {
            NSLog(@"Error illegal argument exception");
            return;
        }
    } else {
        NSLog(@"Error illegal argument exception");
        return;
    }
    instance.urlStringForRequest = urlString;
    
    [instance performRequest];
}

-(void)performRequest{
    instance.bankSortSell = nil;
    instance.bankSortBuy = nil;
    
    NSString *urlStr = [instance.urlStringForRequest stringByAppendingString:kSORT_BY_SELL];
    
    if (page > 1) {
    
        NSString *tmp = [NSString stringWithFormat:kPAGE_NUMB, page];
        urlStr = [urlStr stringByAppendingString:tmp];
        
    }
    
    CETUTParcer *parser = [[CETUTParcer alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    [instance.network downloadDataAndUseParcer:parser];
}

-(void)loadDataHandler:(NSNotification *)notification{
    if (!(instance.bankSortSell)){
        instance.bankSortSell = [[NSArray alloc] init];
        CETUTParcer *p = (CETUTParcer *)notification.object;
        instance.bankSortSell = p.objects;
        hasNext = p.hasNext;
        NSString *urlStr = [instance.urlStringForRequest stringByAppendingString:kSORT_BY_BUY];
        
        if (page > 1) {
            
            NSString *tmp = [NSString stringWithFormat:kPAGE_NUMB, page];
            urlStr = [urlStr stringByAppendingString:tmp];
            
        }
        
        CETUTParcer *parser = [[CETUTParcer alloc] initWithURL:[NSURL URLWithString:urlStr]];
        [instance.network downloadDataAndUseParcer:parser];
    } else {
        instance.bankSortBuy = [[NSArray alloc] init];
        CETUTParcer *p = (CETUTParcer *)notification.object;
        instance.bankSortBuy = p.objects;
        
        if (page > 1){
            
            NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:instance.backupSortSell];
            [temp addObjectsFromArray:instance.bankSortSell];
            instance.bankSortSell = temp;
            
            temp = [[NSMutableArray alloc] initWithArray:instance.backupSortBuy];
            [temp addObjectsFromArray:instance.bankSortBuy];
            instance.bankSortBuy = temp;
        }
        
        
        if (sellDisplay){
            instance.displayData = instance.bankSortSell;
        } else {
            instance.displayData = instance.bankSortBuy;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAIN object:nil];
    }
}

-(BOOL)hasNext{
    return hasNext;
}

-(void)nextPage{
    page++;
    instance.backupSortBuy = instance.bankSortBuy;
    instance.backupSortSell = instance.bankSortSell;
 
    
    [instance performRequest];
}

-(void)loadDetailInfoWithURL:(NSURL *)url{
    instance.urlForDetail = url;
    instance.details = [[CETUTDetails alloc] init];
    
    CETUTParcerDetail *parser = [[CETUTParcerDetail alloc] initWithURL:instance.urlForDetail];
    [instance.network downloadDataAndUseParcer:parser];
}

-(void)detailDataLoadNotificationHandler:(NSNotification *)notification{
    
    if ([instance.details.title length] < 1){
        instance.details = notification.object;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",[instance.urlForDetail absoluteString],@"courses"];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        CETUTParcerDetail *parser = [[CETUTParcerDetail alloc] initWithURL:url];
        
        [instance.network downloadDataAndUseParcer:parser];
        
    } else {
        instance.details.currency = ((CETUTDetails *)notification.object).currency;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DETAIL object:instance.details];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
