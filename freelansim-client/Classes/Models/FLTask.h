//
//  FLTask.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLManagedTask.h"

@class FLManagedTask;

@interface FLTask : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *published;
@property (nonatomic,strong) NSString *price;
@property (nonatomic, assign) BOOL isAccuratePrice;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *shortDescription;
@property (nonatomic,strong) NSString *link;

@property (nonatomic) int views;
@property (nonatomic) int commentsCount;
@property (nonatomic,strong) NSString *htmlDescription;
@property (nonatomic,strong) NSString *filesInfo;
@property (nonatomic,strong) NSArray *mental;

@property (nonatomic,strong) NSArray *tags;

-(void)mapFromManagedTask:(FLManagedTask *)task;

@end
