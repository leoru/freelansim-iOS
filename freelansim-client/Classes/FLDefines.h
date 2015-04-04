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



#define DEFAULT_MEDIUM_FONT(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define DEFAULT_REGULAR_FONT(fontSize) [UIFont fontWithName:@"Helvetica Neue" size:fontSize]

#define kBaseNavBarColor [UIColor colorWithRed:0.96 green:0.71 blue:0.29 alpha:1]
#define kNavBarColor [UIColor colorWithRed:0.35 green:0.41 blue:0.48 alpha:1]
#define kDefaultBlueColor [UIColor colorWithRed:0.36 green:0.7 blue:0.93 alpha:1]
#define kDEFAULT_TEXT_COLOR [UIColor colorWithRed:(93/255.f) green:(101/255.f) blue:(119/255.f) alpha:1];