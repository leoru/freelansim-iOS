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
#import "FLInternetConnectionUtils.h"
#import "FLTaskCell.h"

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
    refreshControl = [[ISRefreshControl alloc] init];
    [self.tasksTable addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    
    self.tasks = [NSMutableArray array];
    stopSearch = NO;
    searchQuery = @"";
    page = 1;
    self.searchBar.delegate = self;
    self.tasksTable.delegate = self;
    self.tasksTable.dataSource = self;
    UIEdgeInsets edges;
    edges.left = 10;
    edges.right = 10;
    self.tasksTable.separatorInset = edges;
    self.tasksTable.backgroundColor = [UIColor clearColor];
    self.clearView.backgroundColor = [UIColor patternBackgroundColor];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    
    [self.tasksTable registerNib:[UINib nibWithNibName:@"FLTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FLTaskCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            if(![FLInternetConnectionUtils isConnectedToInternet]){
                cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
                }
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self showErrorNetworkDisabled];
            }else if (![FLInternetConnectionUtils isWebSiteUp]){
                cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
                }
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self showErrorServerDontRespond];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:loadingCellIdentifier owner:nil options:nil][0];
                }
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FLHTTPClient sharedClient] getTasksWithCategories:self.selectedCategories  query:searchQuery page:page++ success:^(NSArray *objects, BOOL *stop) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            stopSearch = *stop;
                            [self.tasks addObjectsFromArray:objects];
                            [self.tasksTable reloadData];
                        });
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self showErrorNetworkDisabled];
                    }];
                });
                
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
            }
        }
    } else {
        FLTaskCell *taskCell = (FLTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        FLTask *task = self.tasks[indexPath.row];
        [taskCell setTask:task];
        cell = taskCell;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tasksTable deselectRowAtIndexPath:indexPath animated:NO];
    selectedTask = self.tasks[indexPath.row];
    [self performSegueWithIdentifier:@"TaskSegue" sender:self];
    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeGradient];
    
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        FLTaskController *taskController = [segue destinationViewController];
        taskController.task = selectedTask;
    } else if ([segue.identifier isEqualToString:@"CategoriesSegue"]) {
        FLCategoriesController *categoriesController = [segue destinationViewController];
        categoriesController.delegate = self;
        categoriesController.selectedCategories = self.selectedCategories.mutableCopy;
    }
}

#pragma mark - Select Category Delegate
-(void)categoriesDidSelected:(NSArray *)categories {
    self.selectedCategories = categories;
    [self refresh];
}

-(void)refresh {
    self.tasks = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.tasksTable reloadData];
    [refreshControl endRefreshing];
}

- (void)viewDidUnload {
    [self setClearView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void)search{
    stopSearch = NO;
    page = 1;
    searchQuery = self.searchBar.text;
    self.tasks = [[NSMutableArray alloc] init];
    [self.tasksTable reloadData];
}

#pragma mark - Search Bar delegate methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar setText:@""];
    searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    [self search];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self search];
    [self.searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        [self search];
        [self.searchBar resignFirstResponder];
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
@end
