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

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = DefaultOrangeColor;
    self.selectedBackgroundView = backgroundView;
}

- (void)setTask:(FLTask *)task
{
    self.labelPrice.backgroundColor = [UIColor clearColor];
    self.labelPrice.layer.borderColor = PriceLabelBorderColor;

    if (task.isAccuratePrice) {
        self.labelPrice.textColor = [UIColor colorWithRed:0.4 green:0.67 blue:0.4 alpha:1];
    } else {
        self.labelPrice.textColor = DefaultLightGreenColor;
    }
    
    self.labelTitle.text = task.title;

    self.labelShortDescription.text = task.shortDescription;
    self.labelShortDescription.backgroundColor = [UIColor clearColor];
    self.labelShortDescription.numberOfLines = 1;
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
