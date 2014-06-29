//
//  FLContact.m
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLContact.h"


@implementation FLContact

-(id)initWithType:(NSString *)type value:(NSString *)value {
    self = [self init];
    if (self) {
        [self setType:type];
        [self setValue:value];
    }

    return self;
}


-(NSURL *)openURL {
    NSString *urlString = [[self prefix] stringByAppendingFormat:@"%@",self.value];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;
}


-(NSString *)prefix {
    if ([self.type isEqualToString:@"mail"]) {
        return @"mailto:";
    } else if ([self.type isEqualToString:@"phone"]) {
        return @"tel:";
    } else if ([self.type isEqualToString:@"site"]) {
        return @"";
    }

    return @"";
}

@end
