//
//  FLTasksController.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTasksController.h"
#import "FLTaskController.h"
#import "SVProgressHUD.h"

@interface FLTasksController ()

@end

@implementation FLTasksController

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
    self.tasks = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    self.tasksTable.delegate = self;
    self.tasksTable.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FLTaskCell";
    static NSString *loadingCellIdentifier = @"LoadingCell";
    static NSString *emptyCellIdentifier = @"FLEmptyCell";
    UITableViewCell *cell;
    
    
    if (indexPath.row == self.tasks.count) {
        if (!stopSearch) {
            cell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:loadingCellIdentifier owner:nil options:nil][0];
            }
            
            [[FLHTTPClient sharedClient] getTasksWithCategories:nil page:page++ success:^(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    stopSearch = *stop;
                    [self.tasks addObjectsFromArray:objects];
                    [self.tasksTable reloadData];
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
            }
        }
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil][0];
        }
        
        UILabel *taskTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *taskCategory = (UILabel *)[cell viewWithTag:2];
        UILabel *taskShortDescription = (UILabel *)[cell viewWithTag:3];
        
        FLTask *task = self.tasks[indexPath.row];
        taskTitle.text = task.title;
        taskCategory.text = task.category;
        taskShortDescription.text = task.shortDescription;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.97f green:0.67f blue:0.44f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedTask = self.tasks[indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeGradient];
    [[FLHTTPClient sharedClient] loadTask:selectedTask withSuccess:^(FLTask *task, AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            selectedTask = task;
            [self performSegueWithIdentifier:@"TaskSegue" sender:self];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        FLTaskController *taskController = [segue destinationViewController];
        taskController.task = selectedTask;
    }
}





@end
