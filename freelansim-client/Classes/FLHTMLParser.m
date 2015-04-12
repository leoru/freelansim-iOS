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


-(NSArray *)parseTaskList {
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
        
        task.datePublished = [[taskNode findChildOfClass:@"published"] contents];
        task.category = [[taskNode findChildOfClass:@"author"] contents];
        task.briefDescription = [[taskNode findChildOfClass:@"description"] contents];
        
        task.title = [[taskNode findChildOfClass:@"task__title"] getAttributeNamed:@"title"];
        
        NSString *relativePath = [[[taskNode findChildOfClass:@"title"] findChildTag:@"a"] getAttributeNamed:@"href"];
        
        task.link = [FLServerHostString stringByAppendingPathComponent:relativePath];
        
        [tasks addObject:task];
    }
    
    return tasks;
}


-(FLTask *)parseTask:(FLTask *)t {
    
    FLTask *task = t;
    HTMLNode *body = [self body];
    
    
    NSArray *infoBlocksA = [body findChildrenOfClass:@"layout-block_bordered"];
    HTMLNode *taskStat1 = [infoBlocksA[2] findChildOfClass:@"user-params"];
    
    HTMLNode *taskStat2 = [taskStat1 findChildOfClass:@"user-params__value"];
    HTMLNode *taskStat3 = [taskStat2 findChildOfClass:@"list"];
    NSArray *list = [taskStat3 findChildrenOfClass:@"list__item data data_statistics"];
    
    HTMLNode *commentCount = [list[0] findChildOfClass:@"data__value"];
    HTMLNode *viewsCount = [list[1] findChildOfClass:@"data__value"];
    
    NSString * str0 =[[commentCount children][0] rawContents ];
    NSString * comments = [str0 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * str1 =[[viewsCount children][0] rawContents ];
    NSString * views = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    task.commentCount = comments.intValue;
    task.viewCount =views.intValue;

    NSArray *infoBlocks = [body findChildrenOfClass:@"task__description"];
    task.htmlDescription = [infoBlocks[0] rawContents];
    NSLog(@"text description %@", task.htmlDescription);
    
    
   


    HTMLNode *secondBlock = infoBlocks[0];
    
    HTMLNode *filesHeaderNode = [secondBlock findChildOfClass:@"file"];
    if (filesHeaderNode) {
        task.filesInfo = [secondBlock rawContents];
    }
    
    NSArray *skillsBlocks = [[body findChildOfClass:@"task__tags"] findChildrenOfClass:@"tags "];
    
    NSArray *tags = [skillsBlocks[0] findChildrenOfClass:@"tags__item"];
    
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (HTMLNode *tag in tags) {
        NSArray *test = [tag findChildrenOfClass:@"tags__item_link"];
        for (HTMLNode *item in test) {
            [tagsArray addObject:item.contents];
        }
    }
    task.tags = tagsArray;
    
    
//    NSArray *mentals = [[skillsBlocks[1] findChildOfClass:@"tags"] findChildrenOfClass:@"mental"];
//    for (HTMLNode *mental in mentals) {
//        [task.mental arrayByAddingObject:mental.contents];
//    }
    
    return task;
}


-(FLFreelancer *)parseFreelancer:(FLFreelancer *)fl {
    FLFreelancer *freelancer = fl;
    HTMLNode *freelancerCard = [[self body] findChildOfClass:@"user-profile__header"];
    
    // image
    NSString *imagePath = [[[freelancerCard findChildOfClass:@"avatar"] findChildTag:@"img"] getAttributeNamed:@"src"];
    freelancer.avatarPath = imagePath;
    
    HTMLNode *sideBar = [[self body] findChildOfClass:@"layout-block layout-block_profile"];
    HTMLNode *contactsNode;
    HTMLNode *messengersNode;
    HTMLNode *statisticsNode;
    HTMLNode *activityNode;
    
    NSArray *sideBarBlocks = [sideBar findChildTags:@"dt"];
    for (HTMLNode *sideBlock in sideBarBlocks) {
        if ([[sideBlock contents] isEqualToString:@"Контакты"]) {
            contactsNode = [[sideBlock nextSibling] nextSibling];
        }
        else if ([[sideBlock contents] isEqualToString:@"Мессенджеры"]) {
            messengersNode = [[sideBlock nextSibling] nextSibling];
        }
        else if ([[sideBlock contents] isEqualToString:@"Статистика"]) {
            statisticsNode = [[sideBlock nextSibling] nextSibling];
        }
        else if ([[sideBlock contents] isEqualToString:@"Активность"]) {
            activityNode = [[sideBlock nextSibling] nextSibling];
        }
    }

    // location
    freelancer.location = [[sideBar findChildOfClass:@"user__location"] contents];

	// contacts
    NSMutableArray *contacts = [NSMutableArray array];
    FLContact *contact;

    // site
    NSString *site;
    HTMLNode *siteNode = [contactsNode findChildOfClass:@"site"];
    if(siteNode){
        site = [siteNode getAttributeNamed:@"href"];
    }
    if (site) {
        contact = [[FLContact alloc] initWithType:@"site" value:site];
        [contacts addObject:contact];
    }
    
    // email
    NSString *email;
    HTMLNode *emailNode = [contactsNode findChildOfClass:@"link_mail"];
    if (emailNode) {
        email = [NSString stringWithFormat:@"%@@%@",[emailNode getAttributeNamed:@"data-mail-name"],[emailNode getAttributeNamed:@"data-mail-host"]];
    }
	if (email) {
        contact = [[FLContact alloc] initWithType:@"mail" value:email];
        [contacts addObject:contact];
    }
    
    // phone
    NSString *phone;
    HTMLNode *phoneNode = [contactsNode findChildOfClass:@"user__phone"];
    if (phoneNode){
        phone = [phoneNode getAttributeNamed:@"data-phone"];
    }
	if (phone) {
        contact = [[FLContact alloc] initWithType:@"phone" value:phone];
        [contacts addObject:contact];
    }
    
    // messengers
	NSArray *messengerEntries = [messengersNode findChildTags:@"li"];
	for (HTMLNode *messengerEntry in messengerEntries) {
		NSString *messengerType = [[messengerEntry findChildOfClass:@"data__label"] contents];
		if (messengerType && [messengerType characterAtIndex:[messengerType length] - 1] == ':')
			messengerType = [messengerType substringToIndex:[messengerType length] - 1];
		NSString *messengerValue = [[messengerEntry findChildOfClass:@"data__value"] contents];
		if (messengerType && messengerValue) {
			contact = [[FLContact alloc] initWithType:messengerType value:messengerValue];
			[contacts addObject:contact];
		}
	}

	freelancer.contacts = contacts;
    
    // about content
    HTMLNode *profileInfo = [[self body] findChildOfClass:@"profile-blocks_info"];
    freelancer.htmlDescription = [[profileInfo findChildOfClass:@"user-data__about"] rawContents];

	// links
	NSMutableArray *links = [NSMutableArray array];
	HTMLNode *linksNode = [profileInfo findChildOfClass:@"user-params user-params_links"];
	NSArray *htmlLinks = [linksNode findChildTags:@"a"];
	for (HTMLNode *htmlLink in htmlLinks) {
		NSString *link = [htmlLink getAttributeNamed:@"href"];
		if (link)
			[links addObject:link];
	}
	freelancer.links = links;
    
    // skill tags
    NSMutableArray *tags = [NSMutableArray array];
    HTMLNode *tagBlock = [profileInfo findChildOfClass:@"tags "];
    NSArray *htmlTags = [tagBlock findChildrenOfClass:@"tags__item"];
    for (HTMLNode *htmlTag in htmlTags) {
        [tags addObject:[htmlTag findChildOfClass:@"tags__item_link"].contents];
    }
    freelancer.tags = tags;
    
    return freelancer;
}


-(NSArray *)parseFreelancerList {
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
        
        // profile
        NSString *relativePath = [[[freelancerNode findChildOfClass:@"user-data__title"] findChildTag:@"a"] getAttributeNamed:@"href"];
        freelancer.profile = [FLServerHostString stringByAppendingString:relativePath];

        //speciality
        freelancer.speciality = [[freelancerNode findChildOfClass:@"user-data__spec"] contents] ;
        freelancer.speciality = [freelancer.speciality stringByTrimmingCharactersInSet:
                                   [NSCharacterSet newlineCharacterSet]];
        // desc
        freelancer.briefDescription = [[freelancerNode findChildOfClass:@"user__description"] contents];
        
        // thumb
        NSString *thumbPath = [[freelancerNode findChildOfClass:@"avatario"] getAttributeNamed:@"src"];
        thumbPath = [thumbPath stringByReplacingOccurrencesOfString:@"50" withString:@"50"];
        freelancer.thumbPath = thumbPath;
        
        [freelancers addObject:freelancer];
    }
    
    return freelancers;
}

@end
