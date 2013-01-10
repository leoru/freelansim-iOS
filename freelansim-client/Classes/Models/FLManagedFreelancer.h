//
//  FLManagedFreelancer.h
//  freelansim-client
//
//  Created by Developer on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FLFreelancer.h"

@class FLManagedTag;

@interface FLManagedFreelancer : NSManagedObject

@property (nonatomic, retain) id avatar;
@property (nonatomic, retain) NSString * avatarPath;
@property (nonatomic, retain) NSDate * date_create;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * htmlDescription;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * thumbPath;
@property (nonatomic, retain) NSSet *tags;
@end

@interface FLManagedFreelancer (CoreDataGeneratedAccessors)

- (void)addTagsObject:(FLManagedTag *)value;
- (void)removeTagsObject:(FLManagedTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

@interface FLManagedFreelancer (Mapping)

-(void)mappingFromFreelancer:(FLFreelancer *)freelancer andImage:(UIImage *)image;

@end
