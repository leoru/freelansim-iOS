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
    FLFreelancer *freelancer = [[FLFreelancer alloc] init];
    freelancer.link = FLDannyFreelansimLink;
    freelancer = [self loadFreelancer:freelancer];
    
}

+(FLFreelancer *)loadFreelancer:(FLFreelancer *)freelancer{
//    [[FLHTTPClient sharedClient] loadFreelancer:freelancer withSuccess:^(FLFreelancer *fl, AFHTTPRequestOperation *operation, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            return fl;
//        });
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            return nil;
//        });
//    }];
}


@end
