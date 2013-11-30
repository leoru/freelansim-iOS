//
//  FLValueTransformer.h
//  freelansim-client
//
//  Created by Developer on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

//трансформация UIImage в NSData и обратно (для хранения в CoreData)
@interface FLValueTransformer : NSValueTransformer

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

- (id)transformedValue:(id)value;

- (id)reverseTransformedValue:(id)value;

@end
