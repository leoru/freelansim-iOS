//
//  UIColor+FreelansimAdditions.m
//  freelansim-client
//
//  Created by Кирилл on 12.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "UIColor+FreelansimAdditions.h"

@implementation UIColor (FreelansimAdditions)

+ (UIColor *)patternBackgroundColor {
	return [self colorWithPatternImage:[UIImage imageNamed:@"grey.png"]];
}

@end
