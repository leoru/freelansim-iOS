//
//  FLTaskControllerViewController.m
//  freelansim-client
//
//  Created by Кирилл Кунст on 17.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTaskController.h"
#import "FLHTMLUtils.h"
#import "SVProgressHUD.h"
#import "FLHTTPClient.h"

@interface FLTaskController ()
{
    int scrollViewHeight;
}
@end

@implementation FLTaskController

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
    [[FLHTTPClient sharedClient] loadTask:self.task withSuccess:^(FLTask *task, AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.task = task;
            [self initUI];
            [SVProgressHUD dismiss];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
	
    
}

-(void)initUI {
    scrollViewHeight = 159;
    
    self.statView.layer.borderWidth = 1.0f;
    self.statView.layer.borderColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.18f alpha:1.00f].CGColor;
    self.statView.backgroundColor = [UIColor colorWithRed:0.88f green:0.87f blue:0.88f alpha:1.00f];
    self.statView.layer.cornerRadius = 5.0f;
    
    
    self.navigationItem.title = self.task.title;
    self.titleLabel.text = self.task.title;
    self.publishedLabel.text = self.task.published;
    self.viewsLabel.text = [NSString stringWithFormat:@"%d",self.task.views];
    self.commentsLabel.text = [NSString stringWithFormat:@"%d",self.task.commentsCount];
    
    self.descriptionWebView.scrollView.bounces = NO;
    self.descriptionWebView.delegate = self;
    self.descriptionWebView.opaque = NO;
    self.descriptionWebView.backgroundColor = [UIColor clearColor];
    
    [self loadHTMLContent];
    [self generateSkillTags];
    self.mainScrollView.contentSize = CGSizeMake(320,scrollViewHeight);

    
}

-(void)loadHTMLContent {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html = [FLHTMLUtils formattedTaskDescription:self.task.htmlDescription];
    [self.descriptionWebView loadHTMLString:html baseURL:baseURL];
}

-(void)generateSkillTags {
    DWTagList *tagList = [[DWTagList alloc] initWithFrame:self.skillsView.frame];
    
    CGRect frame = tagList.frame;
    frame.origin.y = 30;
    [tagList setFrame:frame];
    
    [tagList setTags:self.task.tags];
    
    [self.skillsView addSubview:tagList];
    
    [self.skillsView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setDescriptionWebView:nil];
    [self setViewsLabel:nil];
    [self setCommentsLabel:nil];
    [self setPublishedLabel:nil];
    [self setSkillsView:nil];
    [self setMainScrollView:nil];
    [super viewDidUnload];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.descriptionWebView sizeToFit];
    scrollViewHeight += self.descriptionWebView.frame.size.height + 20;
    
    CGRect skillViewFrame = self.skillsView.frame;
    skillViewFrame.origin.y = self.descriptionWebView.frame.origin.y + self.descriptionWebView.frame.size.height + 10;
    
    self.skillsView.frame = skillViewFrame;
    self.mainScrollView.contentSize = CGSizeMake(320,scrollViewHeight + self.skillsView.frame.size.height);
}
@end
