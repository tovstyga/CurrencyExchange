//
//  CESettings.m
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/13/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import "CESettings.h"

@interface CESettings()

@property (strong, nonatomic) NSMutableDictionary *root;

@end

#define kFAVORITE_CURRENCY @"FavoriteCurrency"
#define kSETTINGS_FILE_NAME @"Settings.plist"
#define kDEFAULT_SETTINGS_FILE_NAME @"Settings"
#define kLOCATION @"Location"
#define kCONVERT_CURRENCY @"ConvertCurrency"

@implementation CESettings

-(id)init{
    self = [super init];
    
    if (self) {
        self.root = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathString]];
        if (self.root == nil){
            self.root = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kDEFAULT_SETTINGS_FILE_NAME ofType:@"plist"]];
        }
        self.favoriteCurrency = [self.root objectForKey:kFAVORITE_CURRENCY];
        self.location = [self.root objectForKey:kLOCATION];
        self.convertCurrency = [self.root objectForKey:kCONVERT_CURRENCY];
    }
    
    return self;
}

-(void)save{
    [self.root setObject:self.location forKey:kLOCATION];
    [self.root writeToFile:[self pathString] atomically:YES];
}

-(NSString *)pathString{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:kSETTINGS_FILE_NAME];
    return  appFile;
}

@end
