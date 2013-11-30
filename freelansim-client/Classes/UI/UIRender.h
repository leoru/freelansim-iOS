//
//  UIRender.h
//  freelansim-client
//
//  Created by Кирилл on 04.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 UI Render for customizing controls
 */
@interface UIRender : NSObject

+(void)renderContactsButton:(UIButton *)button;

+(void)renderMailButton:(UIButton *)button;

+(void)renderNavigationBar:(UINavigationBar *)navigationBar;

+(void)applyStylesheet;

@end
