//
//  FLManagedFreelancer.h
//  
//
//  Created by CPU124C41 on 27/06/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class FLFreelancer, FLManagedContact, FLManagedLink, FLManagedTag;


@interface FLManagedFreelancer : NSManagedObject

@property (nonatomic, retain) id		avatar;
@property (nonatomic, retain) NSDate	*dateCreated;
@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) NSString	*profile;
@property (nonatomic, retain) NSString	*speciality;
@property (nonatomic, retain) NSString	*price;
@property (nonatomic, retain) NSString	*avatarPath;
@property (nonatomic, retain) NSString	*thumbPath;
@property (nonatomic, retain) NSString	*location;
@property (nonatomic, retain) NSString	*briefDescription;
@property (nonatomic, retain) NSString	*htmlDescription;
@property (nonatomic, retain) NSSet		*contacts;
@property (nonatomic, retain) NSSet		*links;
@property (nonatomic, retain) NSSet		*tags;

@end


@interface FLManagedFreelancer (CoreDataGeneratedAccessors)

- (void)addTagsObject:(FLManagedTag *)value;
- (void)removeTagsObject:(FLManagedTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addContactsObject:(FLManagedContact *)value;
- (void)removeContactsObject:(FLManagedContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addLinksObject:(FLManagedLink *)value;
- (void)removeLinksObject:(FLManagedLink *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

@end


@interface FLManagedFreelancer (Mapping)

- (void)mapWithFreelancer:(FLFreelancer *)freelancer andImage:(UIImage *)image;

@end
