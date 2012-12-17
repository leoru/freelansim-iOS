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

@interface FLTasksController : FLBaseController <UITableViewDataSource, UITableViewDelegate> {
    int page;
    BOOL stopSearch;
    FLTask *selectedTask;
}

@property (weak, nonatomic) IBOutlet UITableView *tasksTable;

@property (nonatomic,retain) NSMutableArray *tasks;

@end
