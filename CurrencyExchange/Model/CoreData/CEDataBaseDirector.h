//
//  DataBaseDirector.h
//  CurrencyExchange
//
//  Created by Alex Tovstyga on 10/14/14.
//  Copyright (c) 2014 Alex Tovstyga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CEDataBaseDirector : NSObject

+(CEDataBaseDirector *)instance;

- (NSManagedObjectContext *)contextForBGTask;
- (void)saveContextForBGTask:(NSManagedObjectContext *)backgroundTaskContext;
- (NSManagedObjectContext *)mainContext;
- (void)saveDefaultContext:(BOOL)wait;

@end
