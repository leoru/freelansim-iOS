//
//  FLHTTPClient.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FLTask.h"
#import "FLFreelancer.h"


/**
 Response types
 */

typedef void (^FLHTTPClientSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FLHTTPClientSuccessWithTaskObject)(FLTask *task, AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FLHTTPClientSuccessWithFreelancerObject)(FLFreelancer *freelancer, AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FLHTTPClientSuccessWithArray)(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop);
typedef void (^FLHTTPClientFailure)(AFHTTPRequestOperation *operation, NSError *error);


/**
 HTTP Client for freelansim.ru
 */
@interface FLHTTPClient : AFHTTPClient {
    // callback queue
    dispatch_queue_t _callbackQueue;
}

/**
 Singleton
 */
+(FLHTTPClient *)sharedClient;


/**
 Get tasks by page and category
 */
-(void)getTasksWithCategories:(NSArray *)categories query:(NSString *)query page:(int)page success:(FLHTTPClientSuccessWithArray)success failure:(FLHTTPClientFailure)failure;


/**
 Get freelansers by page and category
 */
-(void)getFreelancersWithCategories:(NSArray *)categories query:(NSString *)query page:(int)page success:(FLHTTPClientSuccessWithArray)success failure:(FLHTTPClientFailure)failure;


/**
 Get task additional info
 */
-(void)loadTask:(FLTask *)task withSuccess:(FLHTTPClientSuccessWithTaskObject)success failure:(FLHTTPClientFailure)failure;


/**
 Get freelancer additional info
 */
-(void)loadFreelancer:(FLFreelancer *)freelancer withSuccess:(FLHTTPClientSuccessWithFreelancerObject)success failure:(FLHTTPClientFailure)failure;
@end
