//
//  FLFreelancerCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFreelancerCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+RadialGradient.h"

@implementation FLFreelancerCell{
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
    animationcomplete = YES;
    isSelected = NO;
    
    CGFloat start[4] ={(232/255.f),(237/255.f),(242/255.f), 1.0};
    
    CGFloat end[4] ={1,1,1,1};
    
    UIImage * im = [UIImage radialGradientImage:self.animationBody.frame.size startColor:start endcolor:end  centre:CGPointMake(0.4,0.4) radius:0.7];
    UIImageView * imageview = [[UIImageView alloc] initWithImage:im];
    
    [self.animationBody addSubview:imageview];
    
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
                             self.animationBody.transform = CGAffineTransformMakeScale(75, 75);
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


- (void)setFreelancer:(FLFreelancer *)freelancer
{

    [self.avatar setImageWithURL:[NSURL URLWithString:freelancer.thumbPath]  placeholderImage:[UIImage imageNamed:@"placeholder_userpic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        self.loadingIndicator.hidden = YES;
        _avatar.hidden = NO;
    }];
    
    self.avatar.layer.cornerRadius = 25;
    self.avatar.layer.masksToBounds = YES;
    self.labelName.text = freelancer.name;
    self.labelCategory.text = freelancer.speciality;
    self.labelShortDescription.text = freelancer.briefDescription;
    self.labelPrice.text = freelancer.price;
}

@end
