//
//  CETUTParcerDetail.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/16/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CETUTParcerDetail.h"
#import "CETUTDetails.h"
#import "CETUTDetailsCurrencyRate.h"

@interface CETUTParcerDetail()

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) CETUTDetails *info;

@end

#define NOTIFICATION_TUT_DETAIL_LOAD @"NOTIFICATION_TUT_DETAIL_LOAD"
#define START_PARSING_KEY @"</div></div></div></div></div>"
#define END_PARSING_KEY @"b-article-share"
#define TITLE_STRING_KEY @"col-c"
#define ADRESS_KEY @"http://maps.tut.by/"

@implementation CETUTParcerDetail

-(instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
        self.info = [[CETUTDetails alloc] init];
    }
    return self;
}

-(NSURL *)url{
    //    return [NSURL URLWithString:@"http://finance.tut.by/banks/rrb/departments/5280/"];
    return _url;
}

+(NSString *)notificationParcerName{

    return NOTIFICATION_TUT_DETAIL_LOAD;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{

    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *data = [html componentsSeparatedByString:@"\n"];
    html = nil;
    
    //NSMutableArray *dataForParse = [[NSMutableArray alloc] init];
    
    BOOL parse = NO;
    if (data.count > 500){
        NSUInteger from;
        NSUInteger to;
        
        for (int i = 400; i < data.count; i++){
            
            NSString *string = (NSString *)data[i];
            
            if ([string isEqualToString:START_PARSING_KEY]){
                parse = YES;
            }
            
            if ([string isEqualToString:END_PARSING_KEY]){
                parse = NO;
                break;
            }
            
            if (parse){
                //parsing
                NSUInteger indexElement = [string rangeOfString:TITLE_STRING_KEY].location;
                if (indexElement != NSNotFound){
                    //title and subtitle
                    NSString *title;
                    NSString *subtitle;
                    
                    from = indexElement + 30;
                    to = [string rangeOfString:@"</h1>"].location;
                    
                    title = [string substringWithRange:NSMakeRange(from, to-from)];
                    from = to + 32;
                    to = [string rangeOfString:@"</div>"].location;
                    
                    subtitle = [string substringWithRange:NSMakeRange(from, to-from)];
                
                    
                    self.info.title = title;
                    self.info.subtitle = subtitle;
                   // NSLog(@"TITLE = %@ SUBTITLE = %@", title, subtitle);
                    
                } else {
                    indexElement = -1;
                    indexElement = [string rangeOfString:ADRESS_KEY].location;
                    if (indexElement != NSNotFound){
                        //adress
                        from = [string rangeOfString:@"_blank"].location + 8;
                        to = [string length] - 8;
                        NSString *adress = [string substringWithRange:NSMakeRange(from, to-from)];
                        
                        self.info.adress = adress;
                      //  NSLog(@"ADDRESS = %@", adress);
                    } else {
                        indexElement = -1;
                        indexElement = [string rangeOfString:@"nowrap"].location;
                        if (indexElement != NSNotFound){
                            //info
                            NSMutableArray *info = [[NSMutableArray alloc] init];
                            
                            from = indexElement + 8;
                            to = [string rangeOfString:@"</span>"].location;
                           
                            [info addObject:[string substringWithRange:NSMakeRange(from, to-from)]];
                            
                            NSArray *tempArray = [string componentsSeparatedByString:@"</p><p>"];
                            
                            for (int j = 1; j < tempArray.count - 1; j++){
                                NSString *s = (NSString *)tempArray[j];
                                if ([s rangeOfString:@"<p>"].location != NSNotFound){
                                    [info addObject:[s substringFromIndex:3]];
                                } else if ([s rangeOfString:@"</p>"].location != NSNotFound){
                                    [info addObject:[s substringToIndex:s.length - 4]];
                                } else {
                                    [info addObject:s];
                                }
                            }
                            
                            
                            self.info.info = info;
                            /*
                            for (NSString *s in info){
                                NSLog(@"%@", s);
                            }*/
                            
                        } else {
                            indexElement = -1;
                            indexElement = [string rangeOfString:@"service_list"].location;
                            if (indexElement != NSNotFound){
                                //service list
                               // NSMusicDirectory *services = [[NSMutableDictionary alloc] init];
                                
                                NSMutableArray *serviceList = [[NSMutableArray alloc] init];
                                
                                NSArray *tmpArray = [string componentsSeparatedByString:@"</li>"];
                                
                                for (NSString *s in tmpArray){
                                    NSString *str = s;
                                    if ([s rangeOfString:@"</a>"].location != NSNotFound){
                                        str = [str substringToIndex:str.length - 4];
                                    }
                                    NSArray *tmp = [str componentsSeparatedByString:@">"];
                                    [serviceList addObject:[tmp lastObject]];
                                }
                               
                                self.info.services = serviceList;
                                
                                /*
                                for (NSString *s in serviceList){
                                    NSLog(@"%@", s);
                                }*/
                                
                            } else {
                                indexElement = -1;
                                indexElement = [string rangeOfString:@"<tr><td>"].location;
                                if (indexElement != NSNotFound){
                                
                                    CETUTDetailsCurrencyRate *curRate = [[CETUTDetailsCurrencyRate alloc] init];
                                    from = indexElement + 8;
                                    to = [string rangeOfString:@"</td>"].location;
                                    curRate.title = [string substringWithRange:NSMakeRange(from, to-from)];
                                    
                                    string = [string substringFromIndex:to+12];
                                    to = [string rangeOfString:@"</b>"].location;
                                    curRate.buy = [string substringWithRange:NSMakeRange(0, to)];
                                    
                                    string = [string substringFromIndex:to+16];
                                    to = [string rangeOfString:@"</b>"].location;
                                    curRate.sell = [string substringWithRange:NSMakeRange(0, to)];
                                    
                                    [self.info.currency addObject:curRate];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:[CETUTParcerDetail notificationParcerName] object:self.info];
}

@end
