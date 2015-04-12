//
//  FLTask.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLManagedTask.h"
#import "KKFromJSONObject.h"


@class FLManagedTask;


@interface FLTask : NSObject <KKFromJSONObject>

@property (nonatomic, retain) NSString	*title;
@property (nonatomic, retain) NSString	*category;
@property (nonatomic, retain) NSString	*price;
@property (nonatomic, assign) BOOL		isAccuratePrice;
@property (nonatomic, retain) NSString	*datePublished;
@property (nonatomic, retain) NSString	*briefDescription;
@property (nonatomic, retain) NSString	*htmlDescription;
@property (nonatomic, retain) NSString	*link;
@property (nonatomic, retain) NSString	*filesInfo;
@property (nonatomic, assign) int		viewCount;
@property (nonatomic, assign) int		commentCount;
@property (nonatomic, retain) NSArray	*mentals;
@property (nonatomic, retain) NSArray	*tags;

-(void)mapWithManagedTask:(FLManagedTask *)task;
-(NSString *)datePublishedWithFormatting;
+(NSString *)dateFormattingFromString:(NSString *)dateString;
@end
