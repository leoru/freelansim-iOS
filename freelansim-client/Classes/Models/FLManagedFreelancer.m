//
//  FLManagedFreelancer.m
//  
//
//  Created by CPU124C41 on 27/06/14.
//
//

#import "FLContact.h"
#import "FLFreelancer.h"
#import "FLManagedFreelancer.h"
#import "FLManagedContact.h"
#import "FLManagedLink.h"
#import "FLManagedTag.h"
#import "FLValueTransformer.h"


@implementation FLManagedFreelancer

@dynamic avatar;
@dynamic dateCreated;
@dynamic name;
@dynamic speciality;
@dynamic price;
@dynamic avatarPath;
@dynamic thumbPath;
@dynamic location;
@dynamic briefDescription;
@dynamic htmlDescription;
@dynamic contacts;
@dynamic links;
@dynamic tags;

@end


@implementation FLManagedFreelancer (Mapping)

-(void)mapWithFreelancer:(FLFreelancer *)freelancer andImage:(UIImage *)image {
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    FLValueTransformer *transformer = [[FLValueTransformer alloc] init];

    self.avatar = [transformer transformedValue:image];
	self.dateCreated = [NSDate date];
    self.name = freelancer.name;
	self.profile = freelancer.profile;
    self.speciality = freelancer.speciality;
    self.price = freelancer.price;
    self.avatarPath = freelancer.avatarPath;
    self.thumbPath = freelancer.thumbPath;
    self.location = freelancer.location;
    self.briefDescription = freelancer.briefDescription;
    self.htmlDescription = freelancer.htmlDescription;

	for (FLContact *contact in freelancer.contacts) {
        FLManagedContact *managedContact = [FLManagedContact MR_createInContext:localContext];
		managedContact.type = contact.type;
		managedContact.value = contact.value;
        managedContact.freelancer = self;
    }

	for (NSString *link in freelancer.links) {
        FLManagedLink *managedLink = [FLManagedLink MR_createInContext:localContext];
        managedLink.value = link;
        managedLink.freelancer = self;
    }

    for (NSString *tag in freelancer.tags) {
        FLManagedTag *managedTag = [FLManagedTag MR_createInContext:localContext];
        managedTag.value = tag;
        managedTag.freelancer = self;
    }
}

@end
