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
    
    HTMLNode *tasksNode = [body findChildOfClass:@"tasks"];
    
    NSArray *tasksNodes = [tasksNode findChildrenOfClass:@"task"];
    
    for (HTMLNode *taskNode in tasksNodes) {
        FLTask *task = [[FLTask alloc] init];
        
        HTMLNode *taskPriceNode = [taskNode findChildOfClass:@"price"];
        NSArray *priceNodes = [taskPriceNode findChildTags:@"span"];
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

-(FLTask *)parseToTask:(FLTask *)task {
    return task;
}
@end
