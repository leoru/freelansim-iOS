//
//  FLManagedTask.m
//  freelansim-client
//
//  Created by Developer on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLManagedTask.h"
#import "FLManagedTag.h"


@implementation FLManagedTask

@dynamic date_create;
@dynamic title;
@dynamic published;
@dynamic price;
@dynamic category;
@dynamic shortDesc;
@dynamic link;
@dynamic views;
@dynamic commentsCount;
@dynamic htmlDescription;
@dynamic tags;

@end

@implementation FLManagedTask (Mapping)

-(void)mapWithTask:(FLTask *)task{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    self.title = task.title;
    self.published = task.published;
    self.price = task.price;
    self.category = task.category;
    self.shortDesc = task.shortDescription;
    self.link = task.link;
    self.views = [NSNumber numberWithInt:task.views];
    self.commentsCount = [NSNumber numberWithInt:task.commentsCount];
    self.htmlDescription = task.htmlDescription;

    for(NSString *tag in task.tags){
        FLManagedTag *newTag = [FLManagedTag MR_createInContext:localContext];
        newTag.name = tag;
        newTag.task = self;
    }
    
}

@end
