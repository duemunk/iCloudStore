//
//  iCloudStore.m
//  3D Dermatomes
//
//  Created by Tobias DM on 15/11/13.
//  Copyright (c) 2013 developmunk. All rights reserved.
//

#import "iCloudStore.h"

@implementation iCloudStore
{
	NSDictionary *iCloudStoreDictionary;
}


+ (iCloudStore *)sharedInstance
{
    static iCloudStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [iCloudStore new];
        // Do any other initialisation stuff here
		[[NSNotificationCenter defaultCenter] addObserver:sharedInstance
												 selector:@selector(iCloudDidChangeExternally:)
													 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
												   object:nil];
    });
    return sharedInstance;
}

- (void)dealloc
{
	// Called sharedInstance since this function doesn't know that
	[[NSNotificationCenter defaultCenter] removeObserver:[iCloudStore sharedInstance]
													name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
}




#define kNewICloudData @"kNewICloudData"
- (void)iCloudDidChangeExternally:(NSNotification *)notificationObject
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNewICloudData object:nil];
}

+ (void)addiCloudChangeObserver:(id)observer selector:(SEL)selector
{
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:kNewICloudData object:nil];
	// Initialize shared instance
	[iCloudStore sharedInstance];
}
+ (void)removeiCloudChangeObserver:(id)observer
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}




// iCloud

+ (BOOL)iCloudSyncIsAvailable
{
	// is iOS 5?
	if(NSClassFromString(@"NSUbiquitousKeyValueStore"))
	{
		// is iCloud enabled
		if([NSUbiquitousKeyValueStore defaultStore])
		{
			return YES;
		}
	}
	return NO;
}

+ (BOOL)iCloudIsAvailableButNotEnabled
{
	// is iOS 5?
	if(NSClassFromString(@"NSUbiquitousKeyValueStore"))
	{
		// iCloud is disabled
		if(![NSUbiquitousKeyValueStore defaultStore])
		{
			return YES;
		}
		else
			NSLog(@"iCloud not enabled");
	}
	else
		NSLog(@"Not an iOS 5 device");
	
	return NO;
}


+ (void)syncObject:(NSObject *)object forKey:(NSString *)key
{
	[[iCloudStore keyValueStore] setObject:object forKey:key];
	[[iCloudStore keyValueStore] synchronize];
}
+ (NSObject *)objectForKey:(NSString *)key
{
	return [[iCloudStore keyValueStore] objectForKey:key];
}



+ (id)keyValueStore
{
	if ([iCloudStore iCloudSyncIsAvailable])
		return [NSUbiquitousKeyValueStore defaultStore];
	else
		return [NSUserDefaults standardUserDefaults];
}

@end
