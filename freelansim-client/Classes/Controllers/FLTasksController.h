//
//  FLTasksController.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"
#import "FLHTTPClient.h"
#import "FLTask.h"
#import "FLCategoriesController.h"
#import "ISRefreshControl.h"

@interface FLTasksController : FLBaseController <UITableViewDataSource, UITableViewDelegate, FLCategoriesDelegate> {
    int page;
    BOOL stopSearch;
    FLTask *selectedTask;
    ISRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UIView *clearView;
@property (weak, nonatomic) IBOutlet UITableView *tasksTable;

@property (nonatomic,retain) NSMutableArray *tasks;
@property (nonatomic,retain) NSArray *selectedCategories;
@end
