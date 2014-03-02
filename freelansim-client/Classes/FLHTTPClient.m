//
//  FLHTTPClient.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLHTTPClient.h"
#import "FLHTMLParser.h"
#import "FLCategory.h"


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
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//        [self setDefaultHeader:@"Accept" value:@"text/html"];
        _callbackQueue = dispatch_queue_create("ru.kunst.freelansim.network-callback-queue", 0);
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
	NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:90.0f];
	return request;
}

-(void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    operation.successCallbackQueue = _callbackQueue;
	operation.failureCallbackQueue = _callbackQueue;
	[super enqueueHTTPRequestOperation:operation];
}


-(void)getTasksWithCategories:(NSArray *)categories query:(NSString *)query page:(int)page success:(FLHTTPClientSuccessWithArray)success failure:(FLHTTPClientFailure)failure {
    
    NSString *categoriesString = @"";
    if (categories) {
        for (FLCategory *category in categories) {
            categoriesString = [categoriesString stringByAppendingFormat:@"%@,",category.subcategories];
        }
    }
    NSString *path = [[[self baseURL] absoluteString] stringByAppendingString:@"tasks.json"];
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:@{@"q":query,@"categories":categoriesString,@"page":@(page)}];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *tasksArray = JSON;
        NSMutableArray *tasks = [NSMutableArray array];
        
        for (NSDictionary *json in tasksArray) {
            FLTask *task = [FLTask objectFromJSON:json];
            [tasks addObject:task];
        }
        
        BOOL stop = NO;
        if (tasks.count == 0) {
            stop = YES;
        }
        
        success(tasks, &stop);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(nil,error);
        }
    }];
    [operation start];
    
}

-(void)loadTask:(FLTask *)task withSuccess:(FLHTTPClientSuccessWithTaskObject)success failure:(FLHTTPClientFailure)failure {
    
    [self getPath:task.link parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *html = (NSData *)responseObject;
        if (html) {
            NSError *error;
            FLHTMLParser *parser = [[FLHTMLParser alloc] initWithData:html error:&error];
            FLTask *t = [parser parseToTask:task];
            success(t,operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

-(void)getFreelancersWithCategories:(NSArray *)categories query:(NSString *)query page:(int)page success:(FLHTTPClientSuccessWithArray)success failure:(FLHTTPClientFailure)failure {
    
    NSString *categoriesString = @"";
    if (categories) {
        for (FLCategory *category in categories) {
            categoriesString = [categoriesString stringByAppendingFormat:@"%@,",category.subcategories];
        }
    }
    
    [self getPath:@"/freelancers" parameters:@{@"q":query, @"categories":categoriesString,@"page":@(page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.request.description);
        NSData *html = (NSData *)responseObject;
        if (html) {
            NSError *error;
            FLHTMLParser *parser = [[FLHTMLParser alloc] initWithData:html error:&error];
            NSArray *freelancers = [parser parseFreelancers];
            
            BOOL stop = NO;
            if (freelancers.count == 0) {
                stop = YES;
            }
            
            success(freelancers,&stop);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
    
}

-(void)loadFreelancer:(FLFreelancer *)freelancer withSuccess:(FLHTTPClientSuccessWithFreelancerObject)success failure:(FLHTTPClientFailure)failure {
    [self getPath:freelancer.link parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *html = (NSData *)responseObject;
        if (html) {
            NSError *error;
            FLHTMLParser *parser = [[FLHTMLParser alloc] initWithData:html error:&error];
            FLFreelancer *fl = [parser parseToFreelancer:freelancer];
            success(fl,operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

@end
