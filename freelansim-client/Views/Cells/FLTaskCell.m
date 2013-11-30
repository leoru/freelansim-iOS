//
//  FLTaskCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLTaskCell.h"

@implementation FLTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setTask:(FLTask *)task
{
    self.labelPrice.backgroundColor = [UIColor clearColor];
    self.labelPrice.layer.borderColor = PriceLabelBorderColor;
    self.labelPrice.textColor = [UIColor colorWithRed:0.88f green:0.58f blue:0.47f alpha:1.00f];;
    
    self.labelTitle.text = task.title;

    self.labelShortDescription.text = task.shortDescription;
    self.labelShortDescription.backgroundColor = [UIColor clearColor];
    self.labelShortDescription.numberOfLines = 4;
    [self.labelShortDescription sizeToFit];
    self.labelPrice.text = task.price;
    [self.labelPrice sizeToFit];
    
    CGRect frame = self.labelPrice.frame;
    frame.size.height += 5;
    frame.size.width += 5;
    self.labelPrice.frame = frame;
    
    self.labelPublished.text = task.published;
    self.labelPublished.textColor = [UIColor lightGrayColor];
}

@end
