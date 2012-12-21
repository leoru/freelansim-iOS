//
//  FLFreelancer.h
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLFreelancer : NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *speciality;
@property (nonatomic,retain) NSString *avatarPath;
@property (nonatomic,retain) NSString *thumbPath;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *site;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *htmlDescription;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSArray *tags;

@end
