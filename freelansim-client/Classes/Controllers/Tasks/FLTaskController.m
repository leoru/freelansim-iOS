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
#import "FLManagedTask.h"

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
    self.loadingView.backgroundColor = [UIColor patternBackgroundColor];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
    });
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setDescriptionWebView:nil];
    [self setViewsLabel:nil];
    [self setCommentsLabel:nil];
    [self setPublishedLabel:nil];
    [self setSkillsView:nil];
    [self setMainScrollView:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Content
-(void)initUI {
    self.loadingView.hidden = YES;
    
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
    [self initTopBar];
    
}
-(void)initTopBar {
    NSString *star;
    if([self isInFavourites]){
        star = @"star_on.png";
    }else{
        star = @"star_off.png";
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:star] style:UIBarButtonItemStyleBordered target:self action:@selector(favoritesClicked)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)loadHTMLContent {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html = [FLHTMLUtils formattedDescription:self.task.htmlDescription];
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
    self.skillsView.backgroundColor = [UIColor clearColor];
}
-(BOOL)isInFavourites{
    NSArray *results = [FLManagedTask MR_findByAttribute:@"link" withValue:self.task.link];
    if([results count] > 0)
        return YES;
    return NO;
}
-(void)addToFavourites{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    FLManagedTask *managedTask = [FLManagedTask MR_createInContext:localContext];
    managedTask.date_create = [NSDate date];
    [managedTask mapWithTask:self.task];
    [localContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        
    }];
    NSArray *results = [FLManagedTask MR_findAll];
    for(FLManagedTask *task in results){
        NSLog(@"%@", task.title);
    }
}
-(void)removeFromFavourites{
    NSArray *results = [FLManagedTask MR_findByAttribute:@"link" withValue:self.task.link];
    for(FLManagedTask *task in results){
        [task MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        
    }];
}

#pragma mark - WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.descriptionWebView sizeToFit];
    scrollViewHeight += self.descriptionWebView.frame.size.height + 20;
    
    CGRect skillViewFrame = self.skillsView.frame;
    skillViewFrame.origin.y = self.descriptionWebView.frame.origin.y + self.descriptionWebView.frame.size.height + 10;
    
    self.skillsView.frame = skillViewFrame;
    self.mainScrollView.contentSize = CGSizeMake(320,scrollViewHeight + self.skillsView.frame.size.height);
}


-(void)favoritesClicked{
    if([self isInFavourites]){
        [self removeFromFavourites];
    }else{
        [self addToFavourites];
    }
    [self initTopBar];
}

@end
