//
//  FLTask.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTask.h"
#import "FLManagedTag.h"

@implementation FLTask

@synthesize tags = _tags;
@synthesize mental = _mental;

- (NSArray *)mental
{
    if (!_mental) {
        _mental = [NSArray array];
    }
    return _mental;
}

- (NSArray *)tags
{
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"job-title: %@ \r\n",self.title];
}

- (void)mapFromManagedTask:(FLManagedTask *)task
{
    self.title = task.title;
    self.published = task.published;
    self.price = task.price;
    self.category = task.category;
    self.shortDescription = task.shortDesc;
    self.link = task.link;
    self.views = task.views.intValue;
    self.commentsCount = task.commentsCount.intValue;
    self.htmlDescription = task.htmlDescription;
    
    NSMutableArray *tags = [NSMutableArray array];
    for(FLManagedTag *tag in task.tags){
        NSString *newTag = tag.name;
        [tags addObject:newTag];
    }
    self.tags = tags;
}

+ (instancetype)objectFromJSON:(NSDictionary *)json
{
    FLTask *task = [[FLTask alloc] init];
    task.title = json[@"title"];
    task.category = json[@"category_name"];
    task.price = json[@"price"];
    task.published = json[@"published_at"];
    task.link = json[@"url"];
    
    NSString *taskDesc = [NSString stringWithFormat:@"%@ / %@",json[@"category_name"], json[@"sub_category_name"]];
    task.shortDescription = taskDesc;
    
    return task;
}

@end
