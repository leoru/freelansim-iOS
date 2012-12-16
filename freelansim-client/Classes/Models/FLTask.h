//
//  FLTask.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLTask : NSObject

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *published;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *shortDescription;
@property (nonatomic,retain) NSString *link;

@property (nonatomic) int views;
@property (nonatomic) int commentsCount;
@property (nonatomic,retain) NSString *htmlDescription;
@property (nonatomic,retain) NSArray *mental;

@property (nonatomic,retain) NSArray *tags;

@end
