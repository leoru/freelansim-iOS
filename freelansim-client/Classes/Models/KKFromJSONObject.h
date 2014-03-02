//
//  KKFromJSONObject.h
//  freelansim
//
//  Created by Kirill Kunst on 02.03.14.
//  Copyright (c) 2014 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKFromJSONObject <NSObject>

+ (instancetype)objectFromJSON:(NSDictionary *)json;

@end
