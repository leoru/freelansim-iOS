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
#import "FLHTMLUtils.h"
#import "DWTagList.h"
#import "FLContactButton.h"
#import "FLManagedFreelancer.h"
#import "FLManagedTag.h"
#import "FLValueTransformer.h"

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
        
    }
    return self;
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    self.loadingView.backgroundColor = [UIColor patternBackgroundColor];
    [super viewDidLoad];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[FLHTTPClient sharedClient] loadFreelancer:self.freelancer withSuccess:^(FLFreelancer *fl, AFHTTPRequestOperation *operation, id responseObject) {
        self.freelancer = fl;
        [self initUI];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    actionSheetTasks = [[NSMutableArray alloc] init];
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
    [self setLoadingView:nil];
    actionSheetTasks = nil;
    [self setFreelancer:nil];
    [super viewDidUnload];
}


#pragma mark - init Content
-(void)initUI {
    self.loadingView.hidden = YES;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonSystemItemOrganize target:self action:@selector(toBookMarks)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = self.freelancer.name;
    
    CGRect avatarFrame = self.avatarView.frame;
    avatarFrame.size.width = 100;
    avatarFrame.size.height = 100;
    self.avatarView.frame = avatarFrame;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarView.layer.cornerRadius = 50;
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarView setImageWithURL:[NSURL URLWithString:self.freelancer.avatarPath]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        self.loader.hidden = YES;
    }];
    
    self.priceLabel.text = self.freelancer.price;
    self.nameLabel.text = self.freelancer.name;
	self.nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
	self.nameLabel.textColor = DefaultBlueColor;
    self.specialityLabel.text = self.freelancer.speciality;
    self.locationLabel.text = self.freelancer.location;
    self.line = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 160.0f, 280.0f, 1.0f)];
    self.line.backgroundColor = [UIColor colorWithRed:0.26f green:0.29f blue:0.32f alpha:1.00f];
    [self.scrollView addSubview:self.line];
    
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    scrollViewHeight = self.line.frame.origin.y + self.line.frame.size.height + 15;
    
    [self initTopBar];
    [self loadHTMLContent];
    [self generateSkillTags];
}


-(void)initTopBar {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    self.navigationItem.rightBarButtonItem = item;
}


-(void)initActionSheet {
    NSMutableArray *actions = [NSMutableArray array];
    if([self isInFavourites])
        [actions addObject:@"Удалить из избранного"];
    else
        [actions addObject:@"Добавить в избранное"];
    [actions addObject:@"Скопировать ссылку"];
    [actions addObject:@"Перейти в Safari"];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    NSRange iPhoneRange = [deviceType rangeOfString:@"iPhone"];
    NSRange iPadRange = [deviceType rangeOfString:@"iPad"];
    
    for (FLContact *contact in self.freelancer.contacts) {
        NSString *action = @"";
        if ([contact.type isEqualToString:@"mail"])
            action = @"Написать письмо";
        else if (([contact.type isEqualToString:@"phone"]) && ((iPadRange.location != NSNotFound) || (iPhoneRange.location != NSNotFound)))
            action = @"Позвонить";
        else if ([contact.type isEqualToString:@"site"])
            action = @"Перейти на сайт";
        
        [actions addObject:action];
    }
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите действие" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for (NSString *action in actions) {
        [self.actionSheet addButtonWithTitle:action];
    }
    [self.actionSheet addButtonWithTitle:@"Cancel"];
    self.actionSheet.cancelButtonIndex = actions.count;
    actionSheetTasks = actions;
}


#pragma mark - Draw content
-(void)drawContactsForm {
    if (self.freelancer.contacts.count > 0) {
        int contactsHeight = 0;
        self.contactsView = [[UIView alloc] init];
        self.contactsView.backgroundColor = [UIColor clearColor];
        self.contactsView.frame = CGRectMake(10.0f, scrollViewHeight, 300.0f, contactsHeight);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.contactsView.frame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(0.0f,5.0f,300.0f,30.0f);
        titleLabel.text = @"Контакты";
        [titleLabel sizeToFit];
        contactsHeight += titleLabel.frame.size.height;
        
        int i = 0;
        for (FLContact *contact in self.freelancer.contacts) {
            FLContactButton *btn = [[FLContactButton alloc] init];
            btn.contact = contact;
            
            btn.frame = CGRectMake(0, (28 * i) + titleLabel.frame.origin.y + titleLabel.frame.size.height, 200.0f, 20.0f);
            [btn setTitle:[NSString stringWithFormat:@"%@: %@", contact.type, contact.value] forState:UIControlStateNormal];
			[UIRender renderContactsButton:btn];
			[btn setTitleColor:DefaultBlueColor forState:UIControlStateNormal];
            
            [btn sizeToFit];
            btn.frame = CGRectMake(btn.frame.origin.x,btn.frame.origin.y,btn.frame.size.width + 10, btn.frame.size.height);
            [self.contactsView addSubview:btn];

            [btn addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
            contactsHeight += btn.frame.size.height;
            i++;
        }
        [self.contactsView addSubview:titleLabel];
        CGRect frame = self.contactsView.frame;
        frame.size.height = contactsHeight;
        [self.contactsView setFrame:frame];
        [self.scrollView addSubview:self.contactsView];
        
    } else {
        self.contactsView = [[UIView alloc] init];
        self.contactsView.backgroundColor = [UIColor clearColor];
        self.contactsView.frame = CGRectMake(10.0f, self.line.frame.origin.y, 300.0f, 0.0f);
    }
    
    scrollViewHeight += self.contactsView.frame.size.height + 10;
}


-(void)drawSkillsView{
    self.skillsView.backgroundColor = [UIColor clearColor];
    CGRect frame = self.skillsView.frame;
    frame.origin.y = scrollViewHeight;
    [self.skillsView setFrame:frame];
}


-(void)loadHTMLContent {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *html = [FLHTMLUtils formattedDescription:self.freelancer.htmlDescription filesInfo:@""];
    NSString *filtered = [[html stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"%@", filtered);
    NSRange range = [filtered rangeOfString:@"<body>(null)</body>"];
    if(range.length > 0){
        html = [FLHTMLUtils descriptionForbidden:html];
    }
    [self.webView loadHTMLString:html baseURL:baseURL];
}


-(void)generateSkillTags {
    DWTagList *tagList = [[DWTagList alloc] initWithFrame:self.skillsView.frame];
    
    CGRect frame = tagList.frame;
    frame.origin.y = 30;
    //frame.size.height = self.freelancer.tags.count * 20;
    [tagList setFrame:frame];
    
    [tagList setTags:self.freelancer.tags];
    [tagList sizeToFit];
    CGSize size = tagList.frame.size;
    [self.skillsView addSubview:tagList];
    frame = self.skillsView.frame;
    frame.size.height = size.height;
    [self.skillsView setFrame:frame];
    self.skillsView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Favourites
-(void)addToFavourites{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    FLManagedFreelancer *freelancer = [FLManagedFreelancer MR_createInContext:localContext];
    [freelancer mapWithFreelancer:self.freelancer andImage:self.avatarView.image];
    
    [localContext MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        
    }];
}


-(void)removeFromFavourites{
    NSArray *results = [FLManagedFreelancer MR_findByAttribute:@"profile" withValue:self.freelancer.profile];
    for(FLManagedFreelancer *freelancer in results){
        [freelancer MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        
    }];
}


-(BOOL)isInFavourites{
    NSArray *results = [FLManagedFreelancer MR_findByAttribute:@"profile" withValue:self.freelancer.profile];
    if([results count]>0)
        return YES;
    return NO;
}


#pragma mark - UIActionSheet delegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSURL *url;
    UIPasteboard *pasteboard;
    switch (buttonIndex) {
        case 0:
            //добавление в избранное
            if([self isInFavourites])
                [self removeFromFavourites];
            else
                [self addToFavourites];
            [self initActionSheet];
            break;
        case 1:
            pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.freelancer.profile;
            break;
        case 2:
            url = [NSURL URLWithString:self.freelancer.profile];
            [[UIApplication sharedApplication] openURL:url];
            break;
        case 3:
        case 4:
        case 5:
            if (buttonIndex >= [actionSheetTasks count])
                return;
            url = [((FLContact *)[self.freelancer.contacts objectAtIndex:buttonIndex - 3]) openURL];
            [[UIApplication sharedApplication] openURL:url];
            break;
    }
}


-(void)showActionSheet:(id)sender{
    [self initActionSheet];
    [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
}


#pragma mark - Contact Button Click
-(void)contactClick:(id)sender {
    FLContactButton *btn = (FLContactButton *)sender;
    NSURL *url = [btn.contact openURL];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView sizeToFit];
    
    CGRect frame = self.webView.frame;
    frame.origin.y = scrollViewHeight;
    self.webView.frame = frame;
    scrollViewHeight += self.webView.frame.size.height + 10;
    [self drawContactsForm];
    if (self.freelancer.tags.count > 0) {
        CGRect skillViewFrame = self.skillsView.frame;
        skillViewFrame.origin.y = scrollViewHeight;
        skillViewFrame.size.height += 50;
        self.skillsView.frame = skillViewFrame;
        
    } else {
        [self.skillsView removeFromSuperview];
    }
    scrollViewHeight += self.skillsView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(320,scrollViewHeight);
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
