//
//  CategoryCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected == YES) {
        [self.customCategoryCheckmark setHidden:NO];
        self.customCategoryTitle.textColor =[UIColor colorWithRed:(82/255.f)
                                                            green:(166/255.f)
                                                             blue:(173/255.f)
                                                            alpha:1];
    }
    else{
        [self.customCategoryCheckmark setHidden:YES];
        self.customCategoryTitle.textColor = kDEFAULT_TEXT_COLOR;
    }
    
        [UIView transitionWithView:self.customCategoryTitle
                          duration:0.2
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
        [UIView transitionWithView:self.customCategoryCheckmark
                          duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
}

@end
