//
//  FLTask.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTask.h"

@implementation FLTask

@synthesize tags = _tags;
@synthesize mental = _mental;

-(NSArray *)mental {
    if (!_mental) {
        _mental = [NSArray array];
    }
    return _mental;
}

-(NSArray *)tags {
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"job-title: %@ \r\n",self.title];
}
@end
