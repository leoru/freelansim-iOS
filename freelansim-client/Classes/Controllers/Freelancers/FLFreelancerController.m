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
#import "FLLinkButton.h"
#import "FLContactButton.h"
#import "FLManagedFreelancer.h"
#import "FLManagedTag.h"
#import "FLValueTransformer.h"

@interface FLFreelancerController ()
{
    __weak IBOutlet UINavigationItem *testNavi;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    self.loadingView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"Фрилансеры";
    
    
    
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

-(void) popBack {[self.navigationController popViewControllerAnimated:YES];}
- (IBAction)swipeAction:(id)sender {[self.navigationController popViewControllerAnimated:YES];}

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
    
    CGRect avatarFrame = self.avatarView.frame;
    avatarFrame.size.width = 50;
    avatarFrame.size.height = 50;
    self.avatarView.frame = avatarFrame;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarView.layer.cornerRadius = 25;
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarView setImageWithURL:[NSURL URLWithString:self.freelancer.avatarPath]  placeholderImage:[UIImage imageNamed:@"placeholder_userpic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        self.loader.hidden = YES;
    }];
    
    self.priceLabel.text = self.freelancer.price;
    self.nameLabel.text = self.freelancer.name;
	self.specialityLabel.text = self.freelancer.speciality;
    self.locationLabel.text = self.freelancer.location;
    
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    
    scrollViewHeight = self.line.frame.origin.y + self.line.frame.size.height + 10;
    
    [self initTopBar];
    [self loadHTMLContent];
    [self generateSkillTags];
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
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(0, 0, 22, 22)];
    [button setTintColor:[UIColor whiteColor]];
    [button setBackgroundImage:[UIImage imageNamed:star] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:starPush] forState:UIControlEventTouchDown];
    [button addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];    [item setCustomView:button];
    
    self.navigationItem.rightBarButtonItem = item;
    
        button.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
    
}

-(void)favoriteAction {
    if([self isInFavourites])
        [self removeFromFavourites];
    else
        [self addToFavourites];
    
    [self initTopBar];
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
        if ([contact.type isEqualToString:@"mail"]) {
            action = @"Написать письмо";
			[actions addObject:action];
		}
        else if (([contact.type isEqualToString:@"phone"]) && ((iPadRange.location != NSNotFound) || (iPhoneRange.location != NSNotFound))) {
            action = @"Позвонить";
			[actions addObject:action];
		}
        else if ([contact.type isEqualToString:@"site"]) {
            action = @"Перейти на сайт";
			[actions addObject:action];
		}
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
-(void)drawLinksForm {
    if (self.freelancer.links.count > 0) {
        int linksHeight = 0;
        self.linksView = [[UIView alloc] init];
        self.linksView.backgroundColor = [UIColor clearColor];
        [self.linksView setClipsToBounds:YES];
        
        
        self.linksView.frame = CGRectMake(15.0f, scrollViewHeight, self.loadingView.frame.size.width-30, linksHeight);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.linksView.frame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(0.0f,0.0f,300.0f,20.0f);
        titleLabel.text = @"Ссылки:";
        [titleLabel setFont:DEFAULT_MEDIUM_FONT(14)];
        titleLabel.textColor = kDEFAULT_TEXT_COLOR;
        [titleLabel sizeToFit];
        
        linksHeight += titleLabel.frame.size.height;

        int i = 0;
        for (NSString *link in self.freelancer.links) {
            FLLinkButton *linkButton = [[FLLinkButton alloc] init];
			linkButton.link = link;

            linkButton.frame = CGRectMake(-4.f, (18 * i) + titleLabel.frame.origin.y + titleLabel.frame.size.height, 240.0f, 16.0f);
            [linkButton setTitle:link forState:UIControlStateNormal];
			[UIRender renderContactsButton:linkButton];
			[linkButton setTitleColor:DefaultBlueColor forState:UIControlStateNormal];
            //[linkButton setBackgroundColor:[UIColor grayColor]];
            [linkButton sizeToFit];
            linkButton.frame = CGRectMake(linkButton.frame.origin.x,linkButton.frame.origin.y,linkButton.frame.size.width + 10, 16.f);
            [self.linksView addSubview:linkButton];

            [linkButton addTarget:self action:@selector(linkClick:) forControlEvents:UIControlEventTouchUpInside];
            linksHeight += linkButton.frame.size.height+2;
            i++;
        }
        [self.linksView addSubview:titleLabel];
        CGRect frame = self.linksView.frame;
       // [self.linksView setBackgroundColor: [UIColor greenColor]];
        frame.size.height = linksHeight;
        [self.linksView setFrame:frame];
        [self.scrollView addSubview:self.linksView];
        
        scrollViewHeight += self.linksView.frame.size.height + 15;
    } else {
        self.linksView = [[UIView alloc] init];
        self.linksView.backgroundColor = [UIColor clearColor];
        self.linksView.frame = CGRectMake(10.0f, self.line.frame.origin.y, 300.0f, 0.0f);
    }

}


#pragma mark - Draw content
-(void)drawContactsForm {
    if (self.freelancer.contacts.count > 0) {
        int contactsHeight = 0;
        self.contactsView = [[UIView alloc] init];
        self.contactsView.backgroundColor = [UIColor clearColor];
        self.contactsView.frame = CGRectMake(15.0f, scrollViewHeight, 300.0f, contactsHeight);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.contactsView.frame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.frame = CGRectMake(0.0f,0.0f,300.0f,30.0f);
        titleLabel.text = @"Контакты:";
        [titleLabel setFont:DEFAULT_MEDIUM_FONT(14)];
        titleLabel.textColor = kDEFAULT_TEXT_COLOR;
        [titleLabel sizeToFit];
        contactsHeight += titleLabel.frame.size.height;
        
        int i = 0;
        for (FLContact *contact in self.freelancer.contacts) {
            FLContactButton *contactButton = [[FLContactButton alloc] init];
            contactButton.contact = contact;
            
            contactButton.frame = CGRectMake(-4.f, (18 * i) + titleLabel.frame.origin.y + titleLabel.frame.size.height, 200.0f, 16.0f);
            [contactButton setTitle:[NSString stringWithFormat:@"%@: %@", contact.type, contact.value] forState:UIControlStateNormal];
			[UIRender renderContactsButton:contactButton];
			[contactButton setTitleColor:DefaultBlueColor forState:UIControlStateNormal];
            
            [contactButton sizeToFit];
            contactButton.frame = CGRectMake(contactButton.frame.origin.x,contactButton.frame.origin.y,contactButton.frame.size.width + 10, 16.f);
            [self.contactsView addSubview:contactButton];

            [contactButton addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
            contactsHeight += contactButton.frame.size.height+2;
            i++;
        }
        [self.contactsView addSubview:titleLabel];
        CGRect frame = self.contactsView.frame;
        frame.size.height = contactsHeight;
        [self.contactsView setFrame:frame];
        //[self.contactsView setBackgroundColor:[UIColor blueColor]];
        [self.scrollView addSubview:self.contactsView];
        scrollViewHeight += self.contactsView.frame.size.height + 15;
        
    } else {
        self.contactsView = [[UIView alloc] init];
        self.contactsView.backgroundColor = [UIColor clearColor];
        self.contactsView.frame = CGRectMake(10.0f, self.linksView.frame.origin.y, 300.0f, 0.0f);
    }
    
    
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
    NSLog(@"HTMLDATA: %@",html);
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


#pragma mark - Link Button Click
-(void)linkClick:(id)sender {
    FLLinkButton *linkButton = (FLLinkButton *)sender;
    NSURL *url = [NSURL URLWithString:[linkButton.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
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
    
    float width = self.loadingView.frame.size.width;
    
    [self.webView setFrame:CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, width-16, self.webView.frame.size.height)];
    
    CGRect frame = self.webView.frame;
    frame.origin.y = scrollViewHeight;
    self.webView.frame = frame;
    scrollViewHeight += self.webView.frame.size.height + 10;
	[self drawLinksForm];
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
    self.scrollView.contentSize = CGSizeMake(width,scrollViewHeight);
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
