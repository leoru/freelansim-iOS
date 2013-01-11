//
//  FLManagedTag.h
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FLManagedFreelancer, FLManagedTask;

@interface FLManagedTag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) FLManagedFreelancer *freelancer;
@property (nonatomic, retain) FLManagedTask *task;

@end
