//
//  FLFirstFavoritesCreator.m
//  freelansim-client
//
//  Created by Developer on 11.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFirstFavoritesCreator.h"
#import "FLHTMLUtils.h"
#import "FLHTTPClient.h"
#import "FLDefines.h"

@implementation FLFirstFavoritesCreator

NSString * const FLKunstFreelansimLink = @"http://freelansim.ru/freelancers/leoru";
NSString * const FLDannyFreelansimLink = @"http://freelansim.ru/freelancers/Razrab";

+(void)createFavorites{
    
    __block FLFreelancer *freelancer = [[FLFreelancer alloc] init];
    freelancer.link = FLDannyFreelansimLink;
    [self loadFreelancer:freelancer completion:^(FLFreelancer *fr) {
        if(fr)
            freelancer = fr;
    }];
    
}

+(void)loadFreelancer:(FLFreelancer *)freelancer completion:(void(^)(FLFreelancer *fr))completion{
    
    [[FLHTTPClient sharedClient] loadFreelancer:freelancer withSuccess:^(FLFreelancer *fl, AFHTTPRequestOperation *operation, id responseObject) {
        completion(fl);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
}


@end
