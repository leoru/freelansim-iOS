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

- (void)setFreelancer:(FLManagedFreelancer *)freelancer
{
    FLValueTransformer *transformer = [[FLValueTransformer alloc] init];
    self.image.image = (UIImage *)[transformer reverseTransformedValue:freelancer.avatar];
    self.labelName.text = freelancer.name;
    self.labelSecondText.text = freelancer.speciality;
    self.labelShortDescription.text = freelancer.desc;
    self.labelPrice.text = freelancer.price;
}

- (void)setTask:(FLManagedTask *)task
{
    self.labelName.text = task.title;
    self.labelSecondText.text = task.category;
    self.labelShortDescription.text = task.shortDesc;
    self.labelPrice.text = task.price;
}

@end
