//
//  FLTaskControllerViewController.m
//  freelansim-client
//
//  Created by Кирилл Кунст on 17.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTaskController.h"

@interface FLTaskController ()

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
	[self initUI];
    
}

-(void)initUI {
    self.statView.layer.borderWidth = 1.0f;
    self.statView.layer.borderColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.18f alpha:1.00f].CGColor;
    self.statView.backgroundColor = [UIColor colorWithRed:0.88f green:0.87f blue:0.88f alpha:1.00f];
    self.statView.layer.cornerRadius = 5.0f;
    
    
    self.navigationItem.title = self.task.title;
    self.titleLabel.text = self.task.title;
    self.publishedLabel.text = self.task.published;
    self.viewsLabel.text = [NSString stringWithFormat:@"%d",self.task.views];
    self.commentsLabel.text = [NSString stringWithFormat:@"%d",self.task.commentsCount];
    
    [self.descriptionWebView loadHTMLString:self.task.htmlDescription baseURL:nil];
    [self.descriptionWebView sizeToFit];
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
    [super viewDidUnload];
}
@end
