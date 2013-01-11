//
//  FLManagedFreelancer.m
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLManagedFreelancer.h"
#import "FLManagedTag.h"
#import "FLValueTransformer.h"


@implementation FLManagedFreelancer

@dynamic avatar;
@dynamic avatarPath;
@dynamic date_create;
@dynamic desc;
@dynamic email;
@dynamic htmlDescription;
@dynamic link;
@dynamic location;
@dynamic name;
@dynamic phone;
@dynamic price;
@dynamic site;
@dynamic speciality;
@dynamic thumbPath;
@dynamic tags;

@end

@implementation FLManagedFreelancer (Map)

-(void)mappingFromFreelancer:(FLFreelancer *)freelancer andImage:(UIImage *)image{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    FLValueTransformer *transformer = [[FLValueTransformer alloc] init];
    self.date_create = [NSDate date];
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
    
    self.avatar = [transformer transformedValue:image];
    
    for(NSString *tag in freelancer.tags){
        
        FLManagedTag *managedTag = [FLManagedTag MR_createInContext:localContext];
        managedTag.name = tag;
        managedTag.freelancer = self;
    }
}

@end
