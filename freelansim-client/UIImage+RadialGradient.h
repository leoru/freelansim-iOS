//
//  RTImageCategorie.h
//  freelansim
//
//  Created by Morozov Ivan on 12.04.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RadialGradient)
+(UIImage *)radialGradientImage:(CGSize)size startColor:(CGFloat [4])startColor endcolor:(CGFloat [4])endColor centre:(CGPoint)centre radius:(float)radius;
@end
