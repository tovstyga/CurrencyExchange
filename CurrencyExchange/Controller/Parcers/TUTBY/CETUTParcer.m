//
//  CE_TUTParcer.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/7/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTParcer.h"
#import "CETUTbyCurrency.h"

@interface CETUTParcer()

//@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSURL *url;

@end

#define NOTIFICATION @"MAIN_PAGE_TUT_BY"

@implementation CETUTParcer

-(instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self){
        self.url = url;
    }
    return self;
}

-(NSURL *)url{
    return _url;
}

+(NSString *)notificationParcerName{
    return NOTIFICATION;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{

    self.hasNext = NO;
    
    self.objects = [[NSMutableArray alloc] init];
    CETUTbyCurrency *tempRecord;
    
    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *data = [html componentsSeparatedByString:@"\n"];
    html = nil;
    
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    if (data.count > 500){
        NSUInteger count = 550;

        if (count > data.count) count = data.count;
        
        for (int i = 400; i < count; i++){
            NSString *temp = (NSString *)data[i];
            if ([temp rangeOfString:@"p-next"].location != NSNotFound) {
                self.hasNext = YES;
            }
            if (([temp rangeOfString:@"<td"].location != NSNotFound) && (temp.length < 1000)){
                [strings addObject:temp];
            }
        }
    }
    data = nil;
   
    for (NSString *s in strings){
       
        if ([s rangeOfString:@"<td><a href"].location != NSNotFound){
            
            if (tempRecord){
                [self.objects addObject:tempRecord];
                tempRecord = [[CETUTbyCurrency alloc] init];
            } else {
                tempRecord = [[CETUTbyCurrency alloc] init];
            }
            
            //URL
            NSUInteger from = [s rangeOfString:@"http"].location;
            NSUInteger to = [s rangeOfString:@"><b>"].location - 1;
            NSString *URL = [s substringWithRange:NSMakeRange(from, to-from)];
            tempRecord.url = [NSURL URLWithString:URL];
            
            
            //BANK NAME
            from = to + 5;
            to = [s rangeOfString:@"</b></a>"].location;
            NSString *name = [s substringWithRange:NSMakeRange(from, to-from)];
            tempRecord.bankName = name;
           
            
            //DEPARTAMENT
            to = [s rangeOfString:@"</span><span class"].location;
            NSString *departament = [s substringToIndex:to];
            NSArray *array = [departament componentsSeparatedByString:@">"];
            departament = array.lastObject;
            tempRecord.departamentName = departament;
            
            
          //  NSLog(@"name : %@ \ndepartament : %@ \nURL : %@", name, departament, URL);
            
        } else if ([s rangeOfString:@"<td class="].location != NSNotFound){
           
            if ([s rangeOfString:@"x="].location != NSNotFound){
                //COORDINATES
                NSUInteger from = [s rangeOfString:@"x="].location+2;
                float x = [[s substringWithRange:NSMakeRange(from, 7)] floatValue];
                from = [s rangeOfString:@"y="].location+2;
                float y = [[s substringWithRange:NSMakeRange(from, 7)] floatValue];
               // NSLog(@"%f %f", x, y);
                
                tempRecord.longitude = x;
                tempRecord.latitude = y;
                
                //DEPARTAMENT ADRESS
                NSUInteger to = [s rangeOfString:@"</a></td>"].location;
                NSString *adress = [s substringToIndex:to];
                NSArray *array = [adress componentsSeparatedByString:@">"];
                adress = [array lastObject];
                tempRecord.departamentAdress = adress;
               // NSLog(@"%@", array.lastObject);
                
            }
        } else if ([s rangeOfString:@"</b></td>"].location != NSNotFound){
            
            //RATE
            NSUInteger to = [s rangeOfString:@"</b></td>"].location;
            NSString *rate = [s substringToIndex:to];
            NSArray *array = [rate componentsSeparatedByString:@">"];
            rate = [array lastObject];
            
            if (tempRecord.buyRate){
                tempRecord.sellRate = rate;
            } else {
                tempRecord.buyRate = rate;
            }
            
        }
        
    }
    if ((self.objects.count == 0) && (tempRecord.bankName)){
        [self.objects addObject:tempRecord];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION object:self];
}

@end
