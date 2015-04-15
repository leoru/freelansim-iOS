//
//  FavouriteCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FavouriteCell.h"
#import "FLValueTransformer.h"
#import "UIImage+RadialGradient.h"
#import "FLTask.h"


@implementation FavouriteCell
{
    BOOL * animationcomplete;
    BOOL * isSelected;
}

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
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    animationcomplete = YES;
    isSelected = NO;
    CGFloat start[4] = {(232/255.f),(237/255.f),(242/255.f), 1.0};
    CGFloat end[4] = {1,1,1,1};
    
    UIImage * im = [UIImage radialGradientImage:self.animationBody.frame.size startColor:start endcolor:end  centre:CGPointMake(0.3,0.4) radius:0.7];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:im];
    
    [self.animationBody addSubview:imageview];
    
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

    isSelected = highlighted;
    if (highlighted) {
        animationcomplete = NO;
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
                                animationcomplete = YES;}];
    } else {
        if (animationcomplete) {
            self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
        }
        
    }
}


- (void)setFreelancer:(FLManagedFreelancer *)freelancer
{
    
    FLValueTransformer *transformer = [[FLValueTransformer alloc] init];
    self.image.image = (UIImage *)[transformer reverseTransformedValue:freelancer.avatar];
    if (self.image.image==nil) [self.image setImage:[UIImage imageNamed:@"placeholder_userpic"]];    
    self.image.layer.cornerRadius = 25;
    self.image.layer.masksToBounds = YES;
    self.labelName.text = freelancer.name;
    self.labelSecondText.text = freelancer.speciality;
    self.labelPrice.text = freelancer.price;
     self.labelTime.text =  @"";
    
    
    
    //new position
    self.labelNameLeftConstrain.constant=73;
    self.labelSecondTextLeftConstraint.constant=73;
    self.labelPriceLeftConstraint.constant=73;
    self.labelName.numberOfLines = 1;
    self.labelName.frame = CGRectMake(self.labelName.frame.origin.x,
                                      self.labelName.frame.origin.y,
                                      self.labelName.frame.size.width,
                                      17);
}

- (void)setTask:(FLManagedTask *)task
{
    self.labelName.numberOfLines = 1;
    self.image.image = nil;
    self.image.layer.cornerRadius = 0;
    self.image.layer.masksToBounds = NO;
    self.labelName.text = task.title;
    self.labelSecondText.text = task.briefDescription;
    self.labelPrice.text = task.price;
     self.labelTime.text =  [FLTask dateFormattingFromString:task.datePublished];
    
    //new position
    self.labelNameLeftConstrain.constant=15;
    self.labelSecondTextLeftConstraint.constant=15;
    self.labelPriceLeftConstraint.constant=15;
    
    float defWidth = self.labelName.frame.size.width;
    [self.labelName sizeToFit];
    self.titleWidth = self.labelName.frame.size.width;
    
    
    
    if (defWidth<self.labelName.frame.size.width) {
        
        self.labelName.numberOfLines = 2;
        [self.labelName setLineBreakMode:NSLineBreakByWordWrapping];
        self.labelName.frame = CGRectMake(self.labelName.frame.origin.x,
                                           self.labelName.frame.origin.y,
                                           defWidth,
                                           37);
    }
    else {
        self.labelName.frame = CGRectMake(self.labelName.frame.origin.x,
                                           self.labelName.frame.origin.y,
                                           defWidth,
                                           17);
    }

    
}



@end
