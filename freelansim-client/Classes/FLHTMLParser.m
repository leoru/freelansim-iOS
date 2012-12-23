//
//  FLHTMLParser.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLHTMLParser.h"
#import "FLContact.h"

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



-(FLFreelancer *)parseToFreelancer:(FLFreelancer *)fl {
    FLFreelancer *freelancer = fl;
    HTMLNode *freelancerCard = [[self body] findChildOfClass:@"freelancer_card"];
    
    // image
    NSString *imagePath = [[[freelancerCard findChildOfClass:@"avatar"] findChildTag:@"img"] getAttributeNamed:@"src"];
    freelancer.avatarPath = [FLServerHostString stringByAppendingPathComponent:imagePath];
    
    //contacts
    
    HTMLNode *contactsNode = [freelancerCard findChildOfClass:@"contacts"];
    NSMutableArray *contacts = [NSMutableArray array];

    NSString *email;
    HTMLNode *emailNode = [contactsNode findChildOfClass:@"mail"];
    if (emailNode) {
        email = [NSString stringWithFormat:@"%@@%@",[emailNode getAttributeNamed:@"data-mail-name"],[emailNode getAttributeNamed:@"data-mail-host"]];
    }
    
    freelancer.email = email;
    FLContact *contact;
    if (freelancer.email) {
        contact = [[FLContact alloc] initWithText:freelancer.email type:@"mail"];
        [contacts addObject:contact];
    }
    
    freelancer.phone = [[contactsNode findChildOfClass:@"phone"] contents];
    if (freelancer.phone) {
        contact = [[FLContact alloc] initWithText:freelancer.phone type:@"phone"];
        [contacts addObject:contact];
    }

    freelancer.site = [[contactsNode findChildOfClass:@"site"] contents];
    if (freelancer.site) {
        contact = [[FLContact alloc] initWithText:freelancer.site type:@"site"];
        [contacts addObject:contact];
    }
    
    freelancer.contacts = contacts;
    
    //location
    freelancer.location = [[[freelancerCard findChildOfClass:@"short_info"] findChildOfClass:@"location"] contents];
    
    // about content
    HTMLNode *about = [freelancerCard findChildOfClass:@"about"];
    NSArray *infoBlocks = [[about findChildOfClass:@"more_information"] findChildrenOfClass:@"block"];
    freelancer.htmlDescription = [infoBlocks[0] rawContents];
    
    // skills
    NSArray *skillsBlocks = [[about findChildOfClass:@"skills_column"] findChildrenOfClass:@"block"];
    NSArray *tags = [[skillsBlocks[0] findChildOfClass:@"tags"] findChildrenOfClass:@"professional"];
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (HTMLNode *tag in tags) {
        [tagsArray addObject:tag.contents];
    }
    freelancer.tags = tagsArray;
    
    return freelancer;
}


-(NSArray *)parseFreelancers {
    NSMutableArray *freelancers = [NSMutableArray array];
    
    HTMLNode *body = [self body];
    
    HTMLNode *freelancersNode = [body findChildOfClass:@"freelancers shortcuts_items"];
    
    NSArray *freelancersNodes = [freelancersNode findChildrenOfClass:@"shortcuts_item"];
    
    for (HTMLNode *freelancerNode in freelancersNodes) {
        FLFreelancer *freelancer = [[FLFreelancer alloc] init];
        
        // price
        HTMLNode *freelancerPriceNode = [freelancerNode findChildOfClass:@"price"];
        NSArray *priceNodes = [freelancerPriceNode findChildTags:@"span"];
        freelancer.price = @"";
        [priceNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HTMLNode *node = (HTMLNode *)obj;
            
            freelancer.price = [freelancer.price stringByAppendingFormat:@" %@",node.contents];
        }];
        
        //name
        freelancer.name = [[[freelancerNode findChildOfClass:@"name"] findChildTag:@"a"]  contents];
        
        // link
        NSString *relativePath = [[[freelancerNode findChildOfClass:@"name"] findChildTag:@"a"] getAttributeNamed:@"href"];
        freelancer.link = [FLServerHostString stringByAppendingString:relativePath];
        
        //speciality
        freelancer.speciality = [[freelancerNode findChildOfClass:@"description"] contents];
        
        // desc
        freelancer.desc = [[freelancerNode findChildOfClass:@"text"] contents];
        
        // thumb
        NSString *thumbPath = [[[[freelancerNode findChildOfClass:@"avatar"] findChildTag:@"a"] findChildTag:@"img"] getAttributeNamed:@"src"];
        freelancer.thumbPath = [FLServerHostString stringByAppendingPathComponent:thumbPath];
        
        
        [freelancers addObject:freelancer];
    }
    
    return freelancers;
}
@end
