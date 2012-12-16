//
//  FLHTTPClient.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLHTTPClient.h"
#import "FLHTMLParser.h"



@implementation FLHTTPClient

+(FLHTTPClient *)sharedClient {
    static FLHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

-(id)init{
    NSURL *baseURL = [NSURL URLWithString:FLServerHostString];
    if (self =[super initWithBaseURL:baseURL]) {
        _callbackQueue = dispatch_queue_create("ru.kunst.freelansim.network-callback-queue", 0);
    }
    return self;
}


//-(void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
//    operation.successCallbackQueue = _callbackQueue;
//	operation.failureCallbackQueue = _callbackQueue;
//	[super enqueueHTTPRequestOperation:operation];
//}

-(void)getTasksWithCategories:(NSArray *)categories page:(int)page success:(FLHTTPClientSuccessWithArray)success failure:(FLHTTPClientFailure)failure {
    
    NSString *categoriesString = @"";
    if (categories) {
        for (NSString *category in categories) {
            categoriesString = [categoriesString stringByAppendingFormat:@"%@,",category];
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@?categories=%@&page=%d",FLServerHostString,categoriesString,page];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *html = (NSData *)responseObject;
        if (html) {
            NSError *error;
            FLHTMLParser *parser = [[FLHTMLParser alloc] initWithData:html error:&error];
            NSArray *tasks = [parser parseTasks];
            
            BOOL stop = NO;
            if (tasks.count == 0) {
                stop = YES;
            }
            
            success(tasks,operation,responseObject, &stop);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

@end
