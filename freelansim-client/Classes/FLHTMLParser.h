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

@interface FLHTMLParser : HTMLParser

-(NSArray *)parseTasks;
-(NSArray *)parseFreelancers;
-(FLTask *)parseToTask:(FLTask *)t;
-(FLFreelancer *)parseToFreelancer:(FLFreelancer *)fl;
@end
