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
#import "FLContact.h"
#import "NUIRenderer.h"
#import "FLHTMLUtils.h"

@interface FLFreelancerController ()
{
    int scrollViewHeight;
}
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
    [self setLocationLabel:nil];
    [self setScrollView:nil];
    [self setLoader:nil];
    [self setWebView:nil];
    [self setSkillsView:nil];
    [super viewDidUnload];
}


-(void)initUI {
    
    scrollViewHeight = 159;
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonSystemItemOrganize target:self action:@selector(toBookMarks)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = self.freelancer.name;
    CGRect avatarFrame = self.avatarView.frame;
    avatarFrame.size.width = 100;
    avatarFrame.size.height = 100;
    self.avatarView.frame = avatarFrame;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFit;
    [self.avatarView setImageWithURL:[NSURL URLWithString:self.freelancer.avatarPath] success:^(UIImage *image, BOOL cached) {
        self.loader.hidden = YES;
    } failure:^(NSError *error) {
        self.loader.hidden = YES;
    }];
    self.priceLabel.text = self.freelancer.price;
    self.nameLabel.text = self.freelancer.name;
    self.specialityLabel.text = self.freelancer.speciality;
    self.locationLabel.text = self.freelancer.location;
    self.line = [[SSLineView alloc] initWithFrame:CGRectMake(20.0f, 160.0f, 280.0f, 2.0f)];
    self.line.lineColor = [UIColor colorWithRed:0.26f green:0.29f blue:0.32f alpha:1.00f];
	[self.scrollView addSubview:self.line];
    [self drawContactsForm];
}

-(void)drawContactsForm {
    if (self.freelancer.contacts.count > 0) {
        UIView *contactsView = [[UIView alloc] init];
        contactsView.backgroundColor = [UIColor clearColor];
        contactsView.frame = CGRectMake(10.0f, self.line.frame.origin.y + 10, 300.0f, 200.0f);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:contactsView.frame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(0.0f,5.0f,300.0f,40.0f);
        titleLabel.text = @"Контакты";
        [titleLabel sizeToFit];
        
        int i = 0;
        for (FLContact *contact in self.freelancer.contacts) {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(0,(i*38) + titleLabel.frame.origin.y + titleLabel.frame.size.height + 10,200.0f,40.0f);
        
            [btn setTitle:contact.text forState:UIControlStateNormal];
            //[NUIRenderer renderButton:btn withClass:@"Button"];
            [btn sizeToFit];
            btn.frame = CGRectMake(btn.frame.origin.x,btn.frame.origin.y,btn.frame.size.width + 10, btn.frame.size.height + 10);
            [contactsView addSubview:btn];
            i++;
        }
        
        [contactsView addSubview:titleLabel];
        [self.scrollView addSubview:contactsView];
    } 
}

-(void)loadHTMLContent {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html = [FLHTMLUtils formattedTaskDescription:self.freelancer.htmlDescription];
    [self.webView loadHTMLString:html baseURL:baseURL];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView sizeToFit];
    scrollViewHeight += self.webView.frame.size.height + 20;
    
    CGRect skillViewFrame = self.skillsView.frame;
    skillViewFrame.origin.y = self.webView.frame.origin.y + self.webView.frame.size.height + 10;
    
    self.skillsView.frame = skillViewFrame;
    self.scrollView.contentSize = CGSizeMake(320,scrollViewHeight + self.skillsView.frame.size.height);
}
@end
