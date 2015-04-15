//
//  FavouriteCell.h
//  freelansim
//
//  Created by Kirill Kunst on 30.11.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLManagedFreelancer.h"
#import "FLManagedTask.h"

@interface FavouriteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelSecondText;
@property (weak, nonatomic) IBOutlet UILabel *labelShortDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIView *animationBody;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelNameLeftConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelSecondTextLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelPriceLeftConstraint;

@property (nonatomic) float titleWidth;


- (void)setFreelancer:(FLManagedFreelancer *)freelancer;

- (void)setTask:(FLManagedTask *)task;


@end
