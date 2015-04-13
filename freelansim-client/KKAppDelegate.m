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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit]];

    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataStore.sqlite"];
    [UIRender applyStylesheet];
    [self loadPreStoringData];
    [UIRender renderTabBarController:(UITabBarController *)self.window.rootViewController];
    
    return YES;
}

-(void)loadPreStoringData
{
    NSUserDefaults *padFactoids = [NSUserDefaults standardUserDefaults];
    int launchCount = [padFactoids integerForKey:@"launchCount" ] + 1;
    [padFactoids setInteger:launchCount forKey:@"launchCount"];
    [padFactoids synchronize];

    if (launchCount == 1) {
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


@end
