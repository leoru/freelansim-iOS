//
//  FLTaskCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLTaskCell.h"
#import "UIImage+RadialGradient.h"

@implementation FLTaskCell{
    BOOL animationcomplete;
    BOOL isSelected;
}

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
    animationcomplete=YES;
    isSelected=NO;
    CGFloat start[4] ={(232/255.f),(237/255.f),(242/255.f), 1.0};
    CGFloat end[4] ={1,1,1,1};
    
    UIImage * im = [UIImage radialGradientImage:self.animationBody.frame.size startColor:start endcolor:end  centre:CGPointMake(0.4,0.4) radius:0.7];
    UIImageView * imageview = [[UIImageView alloc] initWithImage:im];
    
    
    [self.animationBody addSubview:imageview];
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    isSelected = highlighted;
    if (highlighted) {
        animationcomplete=NO;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.animationBody.transform = CGAffineTransformMakeScale(65, 65);
                         }
                         completion:^(BOOL b) {
                             if (!isSelected) {
                                 self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
                             }
                             animationcomplete=YES;                         }];
    } else {
        if (animationcomplete) {
            self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
        }
        
    }
}


- (void)setTask:(FLTask *)task
{
    
    self.labelTitle.numberOfLines = 1;
    self.labelPrice.backgroundColor = [UIColor clearColor];
    self.labelPrice.layer.borderColor = PriceLabelBorderColor;

    if (task.isAccuratePrice) {
        self.labelPrice.textColor = [UIColor colorWithRed:0.4 green:0.67 blue:0.4 alpha:1];
    } else {
        self.labelPrice.textColor = DefaultLightGreenColor;
    }
    
    self.labelTitle.text = task.title;

    self.labelShortDescription.text = task.briefDescription;
    self.labelShortDescription.backgroundColor = [UIColor clearColor];
    self.labelShortDescription.numberOfLines = 1;
    [self.labelShortDescription sizeToFit];
    self.labelPrice.text = task.price;
 
    self.labelPublished.text = task.datePublishedWithFormatting;
    
    float defWidth = self.labelTitle.frame.size.width;
    [self.labelTitle sizeToFit];
    self.titleWidth = self.labelTitle.frame.size.width;
    
    
    
    if (defWidth<self.labelTitle.frame.size.width) {
        
        self.labelTitle.numberOfLines = 2;
        [self.labelTitle setLineBreakMode:NSLineBreakByWordWrapping];
        self.labelTitle.frame = CGRectMake(self.labelTitle.frame.origin.x,
                                         self.labelTitle.frame.origin.y,
                                         defWidth,
                                         38);
            }
    else {
        self.labelTitle.frame = CGRectMake(self.labelTitle.frame.origin.x,
                                           self.labelTitle.frame.origin.y,
                                           defWidth,
                                           18);
    }

    
}

@end
