//
//  FLTask.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTask.h"

@implementation FLTask

-(NSString *)description {
    return [NSString stringWithFormat:@"job-title: %@ \r\n",self.title];
}
@end
