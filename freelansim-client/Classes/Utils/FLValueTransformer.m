//
//  FLValueTransformer.m
//  freelansim-client
//
//  Created by Developer on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLValueTransformer.h"

@implementation FLValueTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (value == nil)
        return nil;
    
    // I pass in raw data when generating the image, save that directly to the database
    if ([value isKindOfClass:[NSData class]])
        return value;
    return UIImagePNGRepresentation((UIImage *)value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:(NSData *)value];
}

@end
