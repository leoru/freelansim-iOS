//
//  FLDefines.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

// Server host string
extern NSString * const FLServerHostString;
extern NSString * const FLMailString;

extern NSString * const errorTitleServerDontRespond;
extern NSString * const errorTitleNetworkDisable;

extern NSString * const errorMessageNetworkDisable;
extern NSString * const errorMessageServertDontRespond;


#define DEFAULT_MEDIUM_FONT(fontSize) [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize]
#define DEFAULT_REGULAR_FONT(fontSize) [UIFont fontWithName:@"Helvetica" size:fontSize]

#define kBaseNavBarColor [UIColor colorWithRed:0.96 green:0.71 blue:0.29 alpha:1]
#define kNavBarColor [UIColor colorWithRed:0.39 green:0.45 blue:0.52 alpha:1]