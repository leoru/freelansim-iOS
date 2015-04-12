//
//  FLFreelancerController.h
//  freelansim-client
//
//  Created by Кирилл on 23.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"
#import "FLFreelancer.h"

@interface FLFreelancerController : FLBaseController <UIWebViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray *actionSheetTasks;
}

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic,retain) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *skillsView;

@property (nonatomic,retain) UIActionSheet *actionSheet;
@property (nonatomic,retain) UIView *linksView;
@property (nonatomic,retain) UIView *contactsView;
@property (nonatomic,retain) FLFreelancer *freelancer;

@end
