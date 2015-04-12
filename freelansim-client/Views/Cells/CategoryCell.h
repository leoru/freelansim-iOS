//
//  CategoryCell.h
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customCategoryTitle;
@property (weak, nonatomic) IBOutlet UIImageView *customCategoryCheckmark;
@end
