//
//  FLTaskControllerViewController.m
//  freelansim-client
//
//  Created by Кирилл Кунст on 17.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTaskController.h"
#import "FLHTMLUtils.h"
#import "FLHTTPClient.h"
#import "FLManagedTask.h"

@interface FLTaskController ()
{
    int scrollViewHeight;
    id  CurrentgestureRecognizerdelegate;
    __weak IBOutlet UIImageView *loadingImageIndicator;
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
    self.loadingView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 0.5;
    fullRotation.repeatCount = HUGE_VAL;
    [loadingImageIndicator.layer addAnimation:fullRotation forKey:@"360"];
    
    self.loadingView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = item;
        self.navigationItem.title = @"Заказы";
    
    [[FLHTTPClient sharedClient] loadTask:self.task withSuccess:^(FLTask *task, AFHTTPRequestOperation *operation, id responseObject) {
        self.task = task;
        [self initUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}


-(void) popBack {[self.navigationController popViewControllerAnimated:YES];}
- (IBAction)swipeAction:(id)sender {[self.navigationController popViewControllerAnimated:YES];}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setDescriptionWebView:nil];
    [self setViewsLabel:nil];
    [self setCommentsLabel:nil];
    [self setPublishedLabel:nil];
    [self setSkillsView:nil];
    [self setMainScrollView:nil];
    [self setLoadingView:nil];
    NSLog(@"unload");

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
    
   // self.statView.layer.borderWidth = 1.0f;
   // self.statView.layer.borderColor = [UIColor colorWithRed:0.31 green:0.38 blue:0.45 alpha:1].CGColor;
   // self.statView.backgroundColor = [UIColor clearColor];
   // self.statView.layer.cornerRadius = 5.0f;
    
    
    //self.task.title;
    self.titleLabel.text = self.task.title;
    self.publishedLabel.text = self.task.datePublishedWithFormatting;
    self.viewsLabel.text = [NSString stringWithFormat:@"%d",self.task.viewCount];
   // NSLog(@"%d",self.task.viewCount);
    self.commentsLabel.text = [NSString stringWithFormat:@"%d",self.task.commentCount];
    
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
     NSString *starPush;
    if([self isInFavourites]){
        star = @"add_to_favorite_filled.png";
        starPush = @"add_to_favorite.png";
    }else{
        star = @"add_to_favorite.png";
        starPush = @"add_to_favorite_filled.png";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 22, 22);
    
    [button setTintColor:[UIColor whiteColor]];
    [button setImage:[UIImage imageNamed:star] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:starPush] forState:UIControlEventTouchDown];
    [button addTarget:self action:@selector(favoritesClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 22, 22);
    [button2 setTintColor:[UIColor whiteColor]];

    [button2 setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"share.png"] forState:UIControlEventTouchDown];
    [button2 addTarget:self action:@selector(clickAnimationNormal:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(clickAnimationNormal:) forControlEvents:UIControlEventTouchUpOutside];
    [button2 addTarget:self action:@selector(clickAnimationPush:) forControlEvents:UIControlEventTouchDown];
    
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 22)];
    
    [backButtonView addSubview:button2];
    
    [button2 addTarget:self action:@selector(actionOpenInBrowser:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *openInBrowserItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    if(self.navigationItem.rightBarButtonItems.count!=0){
        button.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.transform = CGAffineTransformIdentity;
                         
                         }
                         completion:nil];
    }
    else{
        button2.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button2.transform = CGAffineTransformIdentity;
                             
                         }
                         completion:nil];
        
        button.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.transform = CGAffineTransformIdentity;
                             
                         }
                         completion:nil];
    }
    
    
    self.navigationItem.rightBarButtonItems = @[item,openInBrowserItem];
}

-(void)clickAnimationNormal:(UIButton*)sender{
    [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{sender.transform = CGAffineTransformMakeScale(1, 1);} completion:nil];
    
}

-(void)clickAnimationPush:(UIButton*)sender{
    [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{sender.transform = CGAffineTransformMakeScale(0.9, 0.9);} completion:nil];
}

-(void)loadHTMLContent {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html = [FLHTMLUtils formattedDescription:self.task.htmlDescription filesInfo:self.task.filesInfo];
    [self.descriptionWebView loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#5D6577\" size=\"13\">%@</body></html>",html] baseURL:baseURL];
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
    managedTask.dateCreated = [NSDate date];
    [managedTask mapWithTask:self.task];
    [localContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        
    }];
    NSArray *results = [FLManagedTask MR_findAll];
    for(FLManagedTask *task in results){
        NSLog(@"%@", task.title);
        NSLog(@"%d",self.task.viewCount);
        
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
-(void)actionOpenInBrowser:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.task.link]];
}

#pragma mark - WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.descriptionWebView sizeToFit];
    float width = self.loadingView.frame.size.width;
   
       [self.descriptionWebView setFrame:CGRectMake(self.descriptionWebView.frame.origin.x, self.descriptionWebView.frame.origin.y, width-16, self.descriptionWebView.frame.size.height)];
    
    scrollViewHeight += self.descriptionWebView.frame.size.height + 20;
    
    CGRect skillViewFrame = self.skillsView.frame;
    skillViewFrame.origin.y = self.descriptionWebView.frame.origin.y + self.descriptionWebView.frame.size.height + 10;
    
    self.skillsView.frame = skillViewFrame;
    self.mainScrollView.contentSize = CGSizeMake(width,scrollViewHeight + self.skillsView.frame.size.height);
}
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
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
