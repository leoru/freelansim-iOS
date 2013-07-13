//
//  KKAppDelegate.m
//  freelansim-client
//
//  Created by Кирилл on 13.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "KKAppDelegate.h"
#import "UIRender.h"
#import "FLFirstFavoritesCreator.h"

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataStore.sqlite"];
    [UIRender applyStylesheet];
    [self loadPreStoringData];
    // Override point for customization after application launch.
    return YES;
}

-(void)loadPreStoringData{
    NSUserDefaults *padFactoids = [NSUserDefaults standardUserDefaults];
    int launchCount = [padFactoids integerForKey:@"launchCount" ] + 1;
    [padFactoids setInteger:launchCount forKey:@"launchCount"];
    [padFactoids synchronize];
    
    NSLog(@"number of times: %i this app has been launched", launchCount);
    
    if ( launchCount == 1 )
    {
        [FLFirstFavoritesCreator createFavorites:YES];
        [FLFirstFavoritesCreator createFavorites:NO];
    }

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

#pragma mark - Stylesheet

@end
