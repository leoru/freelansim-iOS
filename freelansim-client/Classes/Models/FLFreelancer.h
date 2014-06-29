//
//  FLFreelancer.h
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLManagedFreelancer.h"
#import "KKFromJSONObject.h"


@class FLManagedFreelancer;


@interface FLFreelancer : NSObject <KKFromJSONObject>

@property (nonatomic, retain) NSString   *name;
@property (nonatomic, retain) NSString   *profile;
@property (nonatomic, retain) NSString   *speciality;
@property (nonatomic, retain) NSString   *price;
@property (nonatomic, retain) NSString   *avatarPath;
@property (nonatomic, retain) NSString   *thumbPath;
@property (nonatomic, retain) NSString   *location;
@property (nonatomic, retain) NSString   *briefDescription;
@property (nonatomic, retain) NSString   *htmlDescription;
@property (nonatomic, retain) NSArray    *contacts;
@property (nonatomic, retain) NSArray    *links;
@property (nonatomic, retain) NSArray    *tags;

-(void)mapWithManagedFreelancer:(FLManagedFreelancer *)freelancer;

@end
