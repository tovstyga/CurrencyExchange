//
//  CE_NetWork.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CENetWork.h"
#import "IParcer.h"

@interface CENetWork()

@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfig;

@end

static const int MAXIMUM_CONNECTION_PER_HOST = 1;

@implementation CENetWork

-(id)init{
    self = [super init];
    if (self){
        
        _sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionConfig.HTTPMaximumConnectionsPerHost = MAXIMUM_CONNECTION_PER_HOST;

    }
    return self;
}

-(void)downloadDataAndUseParcer:(id<IParcer>)delegate{

    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.sessionConfig
                                            delegate:delegate
                                       delegateQueue:nil];

    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[delegate url]];
    [task resume];
}

@end
