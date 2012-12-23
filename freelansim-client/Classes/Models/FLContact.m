//
//  FLContact.m
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLContact.h"

@implementation FLContact

-(id)initWithText:(NSString *)text type:(NSString *)type {
    self = [self init];
    if (self) {
        [self setText:text];
        [self setType:type];
    }
    return self;
}
@end
