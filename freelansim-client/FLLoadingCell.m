//
//  MINLoadingCell.m
//  freelansim
//
//  Created by Morozov Ivan on 06.04.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

#import "FLLoadingCell.h"

@implementation FLLoadingCell

@synthesize loadingImage;

-(void)layoutSubviews {
    [super layoutSubviews];
    [self animationDidStart:nil];    
}

-(void)animationDidStart:(CAAnimation *)anim
{
    
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 0.5;
    fullRotation.repeatCount = HUGE_VAL;
    [loadingImage.layer addAnimation:fullRotation forKey:@"360"];
}

@end
