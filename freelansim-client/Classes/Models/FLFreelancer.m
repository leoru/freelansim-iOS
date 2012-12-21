//
//  FLFreelancer.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancer.h"

@implementation FLFreelancer

-(NSArray *)tags {
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

@end
