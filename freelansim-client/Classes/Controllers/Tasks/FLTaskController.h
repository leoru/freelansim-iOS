//
//  FLTaskControllerViewController.h
//  freelansim-client
//
//  Created by Кирилл Кунст on 17.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"
#import "FLTask.h"
#import <QuartzCore/QuartzCore.h>
#import "DWTagList.h"

@interface FLTaskController : FLBaseController <UIWebViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedLabel;
@property (weak, nonatomic) IBOutlet UIView *skillsView;

@property (weak, nonatomic) IBOutlet UIView *statView;
@property (nonatomic,retain) FLTask *task;
@property (nonatomic,retain) UIActionSheet *actionSheet;


@end
