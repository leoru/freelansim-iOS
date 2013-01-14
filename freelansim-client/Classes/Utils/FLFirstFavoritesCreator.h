//
//  FLFirstFavoritesCreator.h
//  freelansim-client
//
//  Created by Developer on 11.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFreelancer.h"

@interface FLFirstFavoritesCreator : NSObject

FOUNDATION_EXPORT NSString *const FLDannyFreelansimLink;
FOUNDATION_EXPORT NSString *const FLKunstFreelansimLink;

+(void)createFavorites:(BOOL)kunst;

@end
