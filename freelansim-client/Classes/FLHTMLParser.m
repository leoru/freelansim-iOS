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
    
    HTMLNode *tasksNode = [body findChildOfClass:@"content-list content-list_tasks"];
    
    NSArray *tasksNodes = [tasksNode findChildrenOfClass:@"task"];
    
    for (HTMLNode *taskNode in tasksNodes) {
        FLTask *task = [[FLTask alloc] init];
        
        HTMLNode *taskPriceNode = [taskNode findChildOfClass:@"task__params params"];
        NSArray *priceNodes = [taskPriceNode findChildTags:@"span"];
        if (priceNodes.count > 0) {
            task.price = @"Цена договорная";
            task.isAccuratePrice = NO;
        } else {
            task.price = taskPriceNode.contents;
            task.isAccuratePrice = YES;
        }
        
        task.published = [[taskNode findChildOfClass:@"published"] contents];
        task.category = [[taskNode findChildOfClass:@"author"] contents];
        task.shortDescription = [[taskNode findChildOfClass:@"description"] contents];
        
        task.title = [[taskNode findChildOfClass:@"task__title"] getAttributeNamed:@"title"];
        
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
    
    HTMLNode *secondBlock = infoBlocks[1];
    HTMLNode *filesHeaderNode = [secondBlock findChildOfClass:@"file"];
    if (filesHeaderNode) {
        task.filesInfo = [secondBlock rawContents];
    }
    
    NSArray *skillsBlocks = [[body findChildOfClass:@"skills_column"] findChildrenOfClass:@"block"];
    
    NSArray *tags = [[skillsBlocks[0] findChildOfClass:@"tags"] findChildrenOfClass:@"professional"];
    
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (HTMLNode *tag in tags) {
        [tagsArray addObject:tag.contents];
    }
    task.tags = tagsArray;
//    NSArray *mentals = [[skillsBlocks[1] findChildOfClass:@"tags"] findChildrenOfClass:@"mental"];
//    for (HTMLNode *mental in mentals) {
//        [task.mental arrayByAddingObject:mental.contents];
//    }
    
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
    
    HTMLNode *phoneNode = [contactsNode findChildOfClass:@"phone"];
    NSString *phone;
    if (phoneNode){
        phone = [phoneNode getAttributeNamed:@"data-phone"];
    }
    freelancer.phone = phone;
    if (freelancer.phone) {
        contact = [[FLContact alloc] initWithText:freelancer.phone type:@"phone"];
        [contacts addObject:contact];
    }
    
    HTMLNode *siteNode = [contactsNode findChildOfClass:@"site"];
    NSString *site;
    if(siteNode){
        site = [siteNode getAttributeNamed:@"href"];
    }
    freelancer.site = site;
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
    if(!freelancer.htmlDescription){
        
    }
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
    
    HTMLNode *freelancersNode = [body findChildWithAttribute:@"id" matchingName:@"freelancers_list" allowPartial:NO];
    
    NSArray *freelancersNodes = [freelancersNode findChildrenOfClass:@"content-list__item"];
    
    for (HTMLNode *freelancerNode in freelancersNodes) {
        FLFreelancer *freelancer = [[FLFreelancer alloc] init];
        
        // price
        HTMLNode *freelancerPriceNode = [freelancerNode findChildOfClass:@"user__price"];
        HTMLNode *countNode = [freelancerPriceNode findChildOfClass:@"count"];
        
        if (countNode) {
            freelancer.price = [countNode contents];
        } else {
            freelancer.price = @"Цена договорная";
        }
        
        //name
        freelancer.name = [[[freelancerNode findChildOfClass:@"user-data__title"] findChildTag:@"a"]  contents];
        
        // link
        NSString *relativePath = [[[freelancerNode findChildOfClass:@"user-data__title"] findChildTag:@"a"] getAttributeNamed:@"href"];
        freelancer.link = [FLServerHostString stringByAppendingString:relativePath];
        
        //speciality
        freelancer.speciality = [[freelancerNode findChildOfClass:@"user-data__spec"] contents] ;
        freelancer.speciality = [freelancer.speciality stringByTrimmingCharactersInSet:
                                   [NSCharacterSet newlineCharacterSet]];
        // desc
        freelancer.desc = [[freelancerNode findChildOfClass:@"user__description"] contents];
        
        // thumb
        NSString *thumbPath = [[freelancerNode findChildOfClass:@"avatario"] getAttributeNamed:@"src"];
        thumbPath = [thumbPath stringByReplacingOccurrencesOfString:@"50" withString:@"50"];
        freelancer.thumbPath = thumbPath;
        
        
        [freelancers addObject:freelancer];
    }
    
    return freelancers;
}
@end
