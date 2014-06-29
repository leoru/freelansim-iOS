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

-(NSArray *)mentals
{
    if (!_mentals) {
        _mentals = [NSArray array];
    }
    return _mentals;
}


-(NSArray *)tags
{
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"job-title: %@ \r\n",self.title];
}


-(void)mapWithManagedTask:(FLManagedTask *)task
{
	self.title = task.title;
	self.category = task.category;
	self.price = task.price;
	//self.isAccuratePrice;
	self.datePublished = task.datePublished;
	self.briefDescription = task.briefDescription;
	self.htmlDescription = task.htmlDescription;
	self.link = task.link;
	//self.filesInfo;
	self.viewCount = task.viewCount.intValue;
	self.commentCount = task.commentCount.intValue;

//	NSMutableArray *mentals = [[NSMutableArray alloc] init];
//	for(FLManagedMental *managedMental in task.mentals){
//		[mentals addObject:managedMental.value];
//	}
//	self.mentals = mentals;

    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for(FLManagedTag *managedTag in task.tags){
        [tags addObject:managedTag.value];
    }
	self.tags = tags;
}


- (NSString *)datePublishedWithFormatting {
    static NSDateFormatter *rfcFormat = nil;
    static NSDateFormatter *displayFormat = nil;
    
    if (rfcFormat == nil) {
        rfcFormat = [[NSDateFormatter alloc] init];
        [rfcFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    
    if (displayFormat == nil)
        displayFormat = [[NSDateFormatter alloc] init];
    
    NSDate *publishDate = [rfcFormat dateFromString:self.datePublished];
    
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
    task.datePublished = json[@"published_at"];
    task.link = json[@"url"];
    
    NSString *description = [NSString stringWithFormat:@"%@ / %@",json[@"category_name"], json[@"sub_category_name"]];
    task.briefDescription = description;
    
    return task;
}

@end
