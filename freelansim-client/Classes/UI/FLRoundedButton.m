//
//  FLRoundedButton.m
//  freelansim
//
//  Created by Kirill Kunst on 13.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

#import "FLRoundedButton.h"

@implementation FLRoundedButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (void)setup
{
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
}

@end
