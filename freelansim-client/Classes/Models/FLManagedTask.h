//
//  FLManagedTask.h
//  
//
//  Created by CPU124C41 on 27/06/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class FLTask, FLManagedTag;


@interface FLManagedTask : NSManagedObject

@property (nonatomic, retain) NSDate	*dateCreated;
@property (nonatomic, retain) NSString	*title;
@property (nonatomic, retain) NSString	*category;
@property (nonatomic, retain) NSString	*price;
@property (nonatomic, retain) NSString	*datePublished;
@property (nonatomic, retain) NSString	*briefDescription;
@property (nonatomic, retain) NSString	*htmlDescription;
@property (nonatomic, retain) NSString	*link;
@property (nonatomic, retain) NSNumber	*viewCount;
@property (nonatomic, retain) NSNumber	*commentCount;
@property (nonatomic, retain) NSSet		*tags;

@end


@interface FLManagedTask (CoreDataGeneratedAccessors)

- (void)addTagsObject:(FLManagedTag *)value;
- (void)removeTagsObject:(FLManagedTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end


@interface FLManagedTask (Mapping)

-(void)mapWithTask:(FLTask *)task;

@end
