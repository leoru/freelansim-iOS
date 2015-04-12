//
//  FLManagedTask.m
//  
//
//  Created by CPU124C41 on 27/06/14.
//
//

#import "FLTask.h"
#import "FLManagedTask.h"
#import "FLManagedTag.h"


@implementation FLManagedTask

@dynamic category;
@dynamic commentCount;
@dynamic dateCreated;
@dynamic htmlDescription;
@dynamic link;
@dynamic price;
@dynamic datePublished;
@dynamic briefDescription;
@dynamic title;
@dynamic viewCount;
@dynamic tags;

@end


@implementation FLManagedTask (Mapping)

-(void)mapWithTask:(FLTask *)task{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];


	self.title = task.title;
	self.category = task.category;
	self.price = task.price;
	self.datePublished = task.datePublished;
	self.briefDescription = task.briefDescription;
	self.htmlDescription = task.htmlDescription;
	self.link = task.link;
	self.viewCount = [NSNumber numberWithInt:task.viewCount];
	self.commentCount = [NSNumber numberWithInt:task.commentCount];
    
    NSLog(@"TASKCOUNT!!! = %d",task.viewCount);
    
    for(NSString *tag in task.tags){
        FLManagedTag *managedTag = [FLManagedTag MR_createInContext:localContext];
        managedTag.value = tag;
        managedTag.task = self;
    }

}

@end
