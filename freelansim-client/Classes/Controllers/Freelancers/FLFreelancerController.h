//
//  FLFreelancerController.h
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"
#import "FLFreelancer.h"
#import "SSToolkit.h"

@interface FLFreelancerController : FLBaseController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic,retain) SSLineView *line;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *skillsView;
@property (nonatomic,retain) FLFreelancer *freelancer;
@end
