//
//  FLHTMLParser.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"
#import "FLTask.h"
#import "FLFreelancer.h"

// Freelansim.ru html parser
@interface FLHTMLParser : HTMLParser

// Parse list of tasks from html
-(NSArray *)parseTaskList;

// Parse list of freelancers from html
-(NSArray *)parseFreelancerList;

// Parse task data from html
-(FLTask *)parseTask:(FLTask *)t;

// Parse freelancer data from html
-(FLFreelancer *)parseFreelancer:(FLFreelancer *)fl;

@end
