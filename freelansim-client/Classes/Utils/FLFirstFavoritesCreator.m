//
//  FLFirstFavoritesCreator.m
//  freelansim-client
//
//  Created by Daniyar Slahutdinov on 11.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFirstFavoritesCreator.h"
#import "FLHTMLUtils.h"
#import "FLHTTPClient.h"
#import "FLDefines.h"

@implementation FLFirstFavoritesCreator

NSString * const FLKunstFreelansimLink = @"http://freelansim.ru/freelancers/leoru";
NSString * const FLDannyFreelansimLink = @"http://freelansim.ru/freelancers/Razrab";

+(void)createFavorites:(BOOL) kunst{
    
    __block FLFreelancer *freelancer = [[FLFreelancer alloc] init];
    if(kunst)
        freelancer.link = FLKunstFreelansimLink;
    else
        freelancer.link = FLDannyFreelansimLink;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadFreelancer:freelancer completion:^(FLFreelancer *fr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(fr){
                    NSArray *results = [FLManagedFreelancer MR_findByAttribute:@"link" withValue:freelancer.link];
                    if([results count] == 0){
                        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
                        freelancer = fr;
                        if(kunst){
                            freelancer.name = @"Кирилл Кунст";
                            freelancer.price = @"от 500 руб. в час";
                            freelancer.desc = @"Разработка мобильных приложений iOS, Android.\r\nРазработка веб-приложений Ruby on Rails, Sinatra, PHP (Kohana, FuelPHP, Yii, Laravel, Fat-Free Framework).\r\nВы можете посмотреть реализованные мной проекты на linkedin в режиме view full profile.";
                            freelancer.speciality = @"Мобильные приложения";
                        }else{
                            freelancer.name = @"Данияр Салахутдинов";
                            freelancer.price = @"от 400 руб. в час";
                            freelancer.desc = @"Разработка мобильных приложений iOS.\r\nРазработка приложений .net (Entity Framework, LinQ, модульное тестирование и прочее)";
                            freelancer.speciality = @"Разработчик iOS";
                        }
                        FLManagedFreelancer *managedOne = [FLManagedFreelancer MR_createInContext:localContext];

                        UIImage *img;
                        if(kunst)
                            img = [UIImage imageNamed:@"KunstImage.png"];
                        else
                            img = [UIImage imageNamed:@"DannyImage.png"];
                        
                        [managedOne mappingFromFreelancer:freelancer andImage:img];
                        
                        [localContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
                            
                        }];
                    }
                }
            });
        }];
    });

    
}

+(void)loadFreelancer:(FLFreelancer *)freelancer completion:(void(^)(FLFreelancer *fr))completion{
    
    [[FLHTTPClient sharedClient] loadFreelancer:freelancer withSuccess:^(FLFreelancer *fl, AFHTTPRequestOperation *operation, id responseObject) {
        completion(fl);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
}


@end
