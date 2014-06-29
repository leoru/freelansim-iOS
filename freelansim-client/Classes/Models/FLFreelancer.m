//
//  FLFreelancer.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLContact.h"
#import "FLFreelancer.h"
#import "FLManagedContact.h"
#import "FLManagedLink.h"
#import "FLManagedTag.h"


@implementation FLFreelancer

-(NSArray *)contacts {
    if (!_contacts) {
        _contacts = [NSArray array];
    }
    return _contacts;
}


-(NSArray *)links {
    if (!_links) {
        _links = [NSArray array];
    }
    return _links;
}


-(NSArray *)tags {
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}


-(void)mapWithManagedFreelancer:(FLManagedFreelancer *)freelancer{
    
    self.name = freelancer.name;
	self.profile = freelancer.profile;
    self.speciality = freelancer.speciality;
    self.price = freelancer.price;
    self.avatarPath = freelancer.avatarPath;
    self.thumbPath = freelancer.thumbPath;
    self.location = freelancer.location;
    self.briefDescription = freelancer.briefDescription;
    self.htmlDescription = freelancer.htmlDescription;

	NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for(FLManagedContact *managedContact  in freelancer.contacts){
		FLContact *contact = [[FLContact alloc] initWithType:managedContact.type value:managedContact.value];
        [contacts addObject:contact];
    }
    self.tags = contacts;

	NSMutableArray *links = [[NSMutableArray alloc] init];
    for(FLManagedLink *managedLink in freelancer.links){
        [links addObject:managedLink.value];
    }
    self.links = links;
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for(FLManagedTag *managedTag in freelancer.tags){
        [tags addObject:managedTag.value];
    }
    self.tags = tags;
}


+(FLFreelancer *)objectFromJSON:(NSDictionary *)json{
    return nil;
}

@end
