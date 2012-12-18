//
//  FLHTMLUtils.h
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLHTMLUtils : NSObject

+(NSString *)taskCSS;
+(NSString *)formattedTaskDescription:(NSString *)taskHTML;
@end
