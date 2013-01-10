//
//  FLManagedTask.h
//  freelansim-client
//
//  Created by Developer on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FLTask.h"

@class FLManagedTag;

@interface FLManagedTask : NSManagedObject

@property (nonatomic, retain) NSDate * date_create;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * published;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * shortDesc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * views;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSString * htmlDescription;
@property (nonatomic, retain) NSSet *tags;
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
