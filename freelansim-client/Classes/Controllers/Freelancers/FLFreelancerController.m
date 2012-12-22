//
//  FLFreelancerController.m
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancerController.h"
#import "UIImageView+WebCache.h"
#import "FLHTTPClient.h"
#import "SVProgressHUD.h"

@interface FLFreelancerController ()

@end

@implementation FLFreelancerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FLHTTPClient sharedClient] loadFreelancer:self.freelancer withSuccess:^(FLFreelancer *fl, AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.freelancer = fl;
            [self initUI];
            [SVProgressHUD dismiss];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
	[self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAvatarView:nil];
    [self setNameLabel:nil];
    [self setSpecialityLabel:nil];
    [self setPriceLabel:nil];
    [self setViewsLabel:nil];
    [super viewDidUnload];
}


-(void)initUI {
    [self.avatarView setImageWithURL:[NSURL URLWithString:self.freelancer.link]];
    self.priceLabel.text = self.freelancer.price;
    self.nameLabel.text = self.freelancer.name;
    self.specialityLabel.text = self.freelancer.speciality;
}
@end
