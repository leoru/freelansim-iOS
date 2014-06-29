//
//  FLContact.h
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLContact : NSObject

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *value;

-(id)initWithType:(NSString *)type value:(NSString *)value;
-(NSURL *)openURL;

@end
