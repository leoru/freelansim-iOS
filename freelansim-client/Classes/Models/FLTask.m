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

- (NSString *)publishedWithFormatting {
    static NSDateFormatter *rfcFormat = nil;
    static NSDateFormatter *displayFormat = nil;
    
    if (rfcFormat == nil) {
        rfcFormat = [[NSDateFormatter alloc] init];
        [rfcFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    
    if (displayFormat == nil)
        displayFormat = [[NSDateFormatter alloc] init];
    
    NSDate *publishDate = [rfcFormat dateFromString:self.published];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *publishDateComponents = [calendar components:NSYearCalendarUnit|NSDayCalendarUnit fromDate:publishDate];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if (publishDateComponents.year == todayComponents.year) {
        if (publishDateComponents.day == todayComponents.day)
            [displayFormat setDateFormat:@"'Сегодня,' HH:mm"];
        else if (publishDateComponents.day == todayComponents.day - 1)
            [displayFormat setDateFormat:@"'Вчера,' HH:mm"];
        else
            [displayFormat setDateFormat:@"dd MMMM HH:mm"];
    }
    else
        [displayFormat setDateFormat:@"dd MMMM yyyy HH:mm"];
    
    return [displayFormat stringFromDate:publishDate];
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
