//
//  FLFreelancer.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancer.h"
#import "FLManagedTag.h"

@implementation FLFreelancer

-(NSArray *)tags {
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

-(void)mappingWithManagedFreelancer:(FLManagedFreelancer *)freelancer{
    self.name = freelancer.name;
    self.link = freelancer.link;
    self.price = freelancer.price;
    self.speciality = freelancer.speciality;
    self.avatarPath = freelancer.avatarPath;
    self.thumbPath = freelancer.thumbPath;
    self.location = freelancer.location;
    self.site = freelancer.site;
    self.email = freelancer.email;
    self.phone = freelancer.phone;
    self.htmlDescription = freelancer.htmlDescription;
    self.desc = freelancer.desc;
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for(FLManagedTag *tag in freelancer.tags){
        [tags addObject:tag.name];
    }
    self.tags = tags;
}

@end
