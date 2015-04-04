//
//  FavouriteCell.m
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FavouriteCell.h"
#import "FLValueTransformer.h"


@implementation FavouriteCell

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

- (void)setSelectColor
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:(245/255.f)
                                                     green:(172/255.f)
                                                      blue:(66/255.f)
                                                     alpha:1];
    self.selectedBackgroundView = backgroundView;
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
    
    //new position
    self.labelName.frame = CGRectMake(74, 8, 230, self.labelName.frame.size.height);
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
    
    //new position
    self.labelName.frame = CGRectMake(15, 8, 280, self.labelName.frame.size.height);
    self.labelSecondText.frame = CGRectMake(15, 34, 280, self.labelSecondText.frame.size.height);
    self.labelPrice.frame = CGRectMake(15, 58, 280, self.labelPrice.frame.size.height);
    
}



@end
