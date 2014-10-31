//
//  CE_MetalRateParcer.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/6/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CEMetalRateParcer.h"
#import "CEMetalRateXMLDelegate.h"

@interface CEMetalRateParcer()

@property (strong, nonatomic) NSURL *url;

@end

#define kURL @"http://www.nbrb.by/Services/XmlMetals.aspx?metalId=%@"
#define kNOTIFICATION_PARCER_NAME @"MetalRateLoaded"

@implementation CEMetalRateParcer

-(id)init{
    return nil;
}

-(instancetype)initWithMetalID:(NSString *)ID{
    self =[super init];
    if (self){
        self.metalID = ID;
        self.url = [NSURL URLWithString:[NSString stringWithFormat:kURL, self.metalID]];
    }
    return self;
}

-(NSURL *)url{
    return _url;
}

-(NSArray *)parceData:(NSData *)downloadData{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:downloadData];
    
    CEMetalRateXMLDelegate *delegate = [[CEMetalRateXMLDelegate alloc] init];
    [parser setDelegate:delegate];
    
    [parser parse];
    
    if ([parser parserError]){
        NSLog(@"%@", [parser parserError]);
    }
    
    return [delegate results];
}

+(NSString *)notificationParcerName{
    return kNOTIFICATION_PARCER_NAME;
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (data){
        
        self.results = [self parceData:data];

        [[NSNotificationCenter defaultCenter] postNotificationName:[CEMetalRateParcer notificationParcerName] object:self];
    }
    
}

@end
