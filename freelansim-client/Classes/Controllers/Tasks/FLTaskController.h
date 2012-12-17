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

@interface FLTaskController : FLBaseController

@property (weak, nonatomic) IBOutlet UIView *statView;
@property (nonatomic,retain) FLTask *task;
@end
