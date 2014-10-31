//
//  IParcer.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/3/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IParcer <NSObject, NSURLSessionDownloadDelegate>

-(NSURL *)url;

+(NSString *)notificationParcerName;

@end
