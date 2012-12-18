//
//  FLCategory.h
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLCategory : NSObject

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *subcategories;

-(id)initWithTitle:(NSString *)title subcategories:(NSString *)subcategories;

+(NSArray *)categories;
@end
