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
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Set the background for any states you plan to use
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
}

+(void)renderNavigationBar:(UINavigationBar *)navigationBar {
    navigationBar.tintColor = PrimaryNavBarColor;
}
@end
