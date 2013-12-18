//
//  UIRender.m
//  freelansim-client
//
//  Created by Кирилл on 04.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "UIRender.h"

@implementation UIRender

+(void)renderContactsButton:(UIButton *)button {
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Set the background for any states you plan to use
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
}

+(void)renderMailButton:(UIButton *)button {
    UIImage *buttonImage = [[UIImage imageNamed:@"big-orange-button"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIImage *buttonImageHighlighted = [[UIImage imageNamed:@"big-orange-button-highlighted"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
}

+(void)renderNavigationBar:(UINavigationBar *)navigationBar {
//    navigationBar.tintColor = PrimaryNavBarColor;
}

+(void)applyStylesheet {
	UINavigationBar *navigationBar = [UINavigationBar appearance];
    //    [navigationBar setBarTintColor:[UIColor colorWithRed:0.98f green:0.97f blue:0.96f alpha:1.00f]];
    [navigationBar setBarTintColor:kBaseNavBarColor];
    
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_MEDIUM_FONT(17),
                                            NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    NSDictionary *barButtonTitleTextAttributes = @{NSFontAttributeName : DEFAULT_MEDIUM_FONT(13.0f),
                                                   NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
    // Navigation back button
    [barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(2.0f, 0.0f) forBarMetrics:UIBarMetricsDefault];
    
    [navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back_button_arrow"]];
    [navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_button_arrow"]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    UITabBar *tabBar = [UITabBar appearance];
    
    [tabBar setTintColor:kBaseNavBarColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
