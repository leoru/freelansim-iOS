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
extern NSString * const crtwebMailString;

extern NSString * const errorTitleServerDontRespond;
extern NSString * const errorTitleNetworkDisable;

extern NSString * const errorMessageNetworkDisable;
extern NSString * const errorMessageServertDontRespond;


#define DEFAULT_MEDIUM_FONT(fontSize) [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize]
#define DEFAULT_REGULAR_FONT(fontSize) [UIFont fontWithName:@"Helvetica" size:fontSize]

#define kBaseNavBarColor [UIColor colorWithRed:0.92f green:0.55f blue:0.42f alpha:1.00f]