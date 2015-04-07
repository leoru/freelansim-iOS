//
//  FLDefines.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLDefines.h"

NSString * const FLServerHostString = @"http://freelansim.ru/";
NSString * const FLMailString = @"mailto:kirillkunst@gmail.com?subject=Freelansim%20Reader:%20feedback";

NSString * const errorTitleServerDontRespond = @"Сайт не доступен";
NSString * const errorTitleNetworkDisable = @"Сеть не доступна";

NSString * const errorMessageNetworkDisable = @"Проверьте настройки интернет";
NSString * const errorMessageServertDontRespond = @"Ошибка на сервере. Попробуйте повторить позднее";

@implementation FLDefines

+(UIImage *)radialGradientImage:(CGSize)size startColor:(CGFloat [4])startColor endcolor:(CGFloat [4])endColor centre:(CGPoint)centre radius:(float)radius {
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    // Create the gradient's colours
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.7, 1.0 };
    CGFloat components[8] = { startColor[0],startColor[1],startColor[2],startColor[3]        ,endColor[0],endColor[1], endColor[2],endColor[3] }; // End color
    
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Normalise the 0-1 ranged inputs to the width of the image
    CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
    float myRadius = MIN(size.width, size.height) * radius;
    
    // Draw it!
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                 0, myCentrePoint, myRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    return image;
}





@end