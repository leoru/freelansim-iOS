//
//  FLFreelancerCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFreelancerCell.h"
#import "UIImageView+WebCache.h"

@implementation FLFreelancerCell

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
    backgroundView.backgroundColor = kDefaultBlueColor;
    self.selectedBackgroundView = backgroundView;
    self.labelPrice.textColor = DefaultLightGreenColor;
}

- (void)setFreelancer:(FLFreelancer *)freelancer
{

    [self.avatar setImageWithURL:[NSURL URLWithString:freelancer.thumbPath]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
