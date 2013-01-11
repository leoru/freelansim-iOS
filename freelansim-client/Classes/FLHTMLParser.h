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

/**
 Freelansim.ru html parser
 */
@interface FLHTMLParser : HTMLParser

/**
 Parse task from html
 */
-(NSArray *)parseTasks;

/**
 Parse freelancers data from html
 */
-(NSArray *)parseFreelancers;

/**
 Parse task data from html
 */
-(FLTask *)parseToTask:(FLTask *)t;

/**
 Parse freelancer data from html
 */
-(FLFreelancer *)parseToFreelancer:(FLFreelancer *)fl;
@end
