//
//  FLHTMLParser.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLHTMLParser.h"

@implementation FLHTMLParser
-(id)initWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    self = [super initWithData:data error:error];
    if (self) {
        
    }
    return self;
}

-(id)initWithString:(NSString *)string error:(NSError *__autoreleasing *)error {
    self = [super initWithString:string error:error];
    if (self) {
        
    }
    return self;
}


-(NSArray *)parseTasks {
    NSMutableArray *tasks = [NSMutableArray array];
    
    HTMLNode *body = [self body];
    
    HTMLNode *tasksNode = [body findChildOfClass:@"tasks shortcuts_items"];
    
    NSArray *tasksNodes = [tasksNode findChildrenOfClass:@"shortcuts_item task"];
    
    for (HTMLNode *taskNode in tasksNodes) {
        FLTask *task = [[FLTask alloc] init];
        
        HTMLNode *taskPriceNode = [taskNode findChildOfClass:@"price"];
        NSArray *priceNodes = [taskPriceNode findChildTags:@"span"];
        task.price = @"";
        [priceNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HTMLNode *node = (HTMLNode *)obj;
            
            task.price = [task.price stringByAppendingFormat:@" %@",node.contents];
        }];
        
        task.published = [[taskNode findChildOfClass:@"published"] contents];
        task.category = [[taskNode findChildOfClass:@"author"] contents];
        task.shortDescription = [[taskNode findChildOfClass:@"description"] contents];
        
        task.title = [[taskNode findChildOfClass:@"title"] getAttributeNamed:@"title"];
        
        NSString *relativePath = [[[taskNode findChildOfClass:@"title"] findChildTag:@"a"] getAttributeNamed:@"href"];
        
        task.link = [FLServerHostString stringByAppendingPathComponent:relativePath];
        
        [tasks addObject:task];
    }
    
    return tasks;
}

-(FLTask *)parseToTask:(FLTask *)t {
    
    FLTask *task = t;
    HTMLNode *body = [self body];
    
    HTMLNode *taskStat = [body findChildOfClass:@"task_stat"];
    task.views = [[[taskStat findChildOfClass:@"views"] contents] intValue];
    task.commentsCount = [[[taskStat findChildOfClass:@"comments"] contents] intValue];
    
    NSArray *infoBlocks = [[body findChildOfClass:@"more_information"] findChildrenOfClass:@"block"];
    task.htmlDescription = [infoBlocks[0] rawContents];
    
    NSArray *skillsBlocks = [[body findChildOfClass:@"skills_column"] findChildrenOfClass:@"block"];
    
    NSArray *tags = [[skillsBlocks[0] findChildOfClass:@"tags"] findChildrenOfClass:@"professional"];
    
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (HTMLNode *tag in tags) {
        [tagsArray addObject:tag.contents];
    }
    task.tags = tagsArray;
    NSArray *mentals = [[skillsBlocks[1] findChildOfClass:@"tags"] findChildrenOfClass:@"mental"];
    for (HTMLNode *mental in mentals) {
        [task.mental arrayByAddingObject:mental.contents];
    }
    
    return task;
}
@end
