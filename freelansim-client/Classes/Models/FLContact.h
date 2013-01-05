//
//  FLContact.h
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLContact : NSObject

-(id)initWithText:(NSString *)text type:(NSString *)type;

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *text;

-(NSURL *)openURL;
@end
