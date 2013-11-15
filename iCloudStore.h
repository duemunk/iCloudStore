//
//  iCloudStore.h
//  3D Dermatomes
//
//  Created by Tobias DM on 15/11/13.
//  Copyright (c) 2013 developmunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iCloudStore : NSObject

+ (iCloudStore *)sharedInstance;

+ (void)addiCloudChangeObserver:(id)observer selector:(SEL)selector;
+ (void)removeiCloudChangeObserver:(id)observer;

+ (void)syncObject:(NSObject *)object forKey:(NSString *)key;
+ (NSObject *)objectForKey:(NSString *)key;

@end
