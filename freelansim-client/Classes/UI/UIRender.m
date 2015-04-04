//
//  UIRender.m
//  freelansim-client
//
//  Created by Кирилл on 04.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "UIRender.h"
#import "UIRender.h"

@implementation UIRender

+(void)renderContactsButton:(UIButton *)button {
    [button setTitleColor:DefaultOrangeColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    
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
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage imageNamed:@"keyline.png"]];
    [navigationBar setTranslucent:NO];
    
    
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_MEDIUM_FONT(17),
                                            NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    NSDictionary *barButtonTitleTextAttributes = @{NSFontAttributeName : DEFAULT_REGULAR_FONT(15.0f),
                                                   NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
    // Navigation back button
    [barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(2.0f, 0.0f) forBarMetrics:UIBarMetricsDefault];
    
    [navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back_button_arrow"]];
    [navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_button_arrow"]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+(void)renderTabBarController:(UITabBarController *)tabBarController{
    
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *offers = [tabBar.items objectAtIndex:0];
    UITabBarItem *freelance = [tabBar.items objectAtIndex:1];
    UITabBarItem *favor = [tabBar.items objectAtIndex:2];
    UITabBarItem *about = [tabBar.items objectAtIndex:3];
    
    UIOffset offset = UIOffsetMake(0,-4);
    NSDictionary *attrebutes = @{NSFontAttributeName : DEFAULT_REGULAR_FONT(11.0f)};
    
    [offers setImage:[UIImage imageNamed:@"offers.png"]];
    [offers setSelectedImage:[UIImage imageNamed:@"offers_active.png"]];
    [offers setTitlePositionAdjustment:offset];
    [offers setTitleTextAttributes:attrebutes forState:UIControlStateNormal];
    
    [freelance setImage:[UIImage imageNamed:@"freelancers.png"]];
    [freelance setSelectedImage:[UIImage imageNamed:@"freelancers_active.png"]];
    [freelance setTitlePositionAdjustment:offset];
    [freelance setTitleTextAttributes:attrebutes forState:UIControlStateNormal];
    
    [favor setImage:[UIImage imageNamed:@"favorites.png"]];
    [favor setSelectedImage:[UIImage imageNamed:@"favorites_active.png"]];
    [favor setTitlePositionAdjustment:offset];
    [favor setTitleTextAttributes:attrebutes forState:UIControlStateNormal];
    
    [about setImage:[UIImage imageNamed:@"about.png"]];
    [about setSelectedImage:[UIImage imageNamed:@"about_active.png"]];
    [about setTitlePositionAdjustment:offset];
    [about setTitleTextAttributes:attrebutes forState:UIControlStateNormal];
    
    
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
    [tabBar setShadowImage:[UIImage imageNamed:@"tab_line.png"]];
    
    [tabBar setTintColor:[UIColor colorWithRed:0.95f green:0.67f blue:0.26f alpha:1]];
    [tabBar setTranslucent:NO];
    
    
}


@end
