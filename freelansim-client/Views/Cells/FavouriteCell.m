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
    self.labelName.frame = CGRectMake(74, 11, 230, self.labelName.frame.size.height);
    self.labelSecondText.frame = CGRectMake(74, 34, 230, self.labelSecondText.frame.size.height);
    self.labelPrice.frame = CGRectMake(74, 58, 230, self.labelPrice.frame.size.height);
}

- (void)setTask:(FLManagedTask *)task
{
    self.image.image = nil;
    self.image.layer.cornerRadius = 0;
    self.image.layer.masksToBounds = NO;
    self.labelName.text = task.title;
    self.labelSecondText.text = task.briefDescription;
    self.labelPrice.text = task.price;
     self.labelTime.text =  [FLTask dateFormattingFromString:task.datePublished];
    
    //new position
    self.labelName.frame = CGRectMake(15, 11, 280, self.labelName.frame.size.height);
    self.labelSecondText.frame = CGRectMake(15, 34, 280, self.labelSecondText.frame.size.height);
    self.labelPrice.frame = CGRectMake(15, 58, 280, self.labelPrice.frame.size.height);
    
}



@end
