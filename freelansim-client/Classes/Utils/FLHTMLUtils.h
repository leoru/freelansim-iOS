//
//  FLHTMLUtils.h
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Format HTML utils
 */
@interface FLHTMLUtils : NSObject

/**
 CSS for html web view
 */
+(NSString *)CSS;

/**
 Formatted description with css
 */
+(NSString *)formattedDescription:(NSString *)HTML filesInfo:(NSString *)filesInfo;

+(NSString *)descriptionForbidden:(NSString *)HTML;

@end
