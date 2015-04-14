//
//  FLTasksController.m
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLTasksController.h"
#import "FLTaskController.h"
#import "FLTaskCell.h"
#import "FLInternetConnectionUtils.h"
#import "FLBannerViewController.h"

@interface FLTasksController ()
@property (weak, nonatomic) IBOutlet UIView *EmptySearch;
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
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tasksTable addSubview:refreshControl];
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
    self.clearView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.categoriesButton setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_REGULAR_FONT(16.0f)} forState:UIControlStateNormal];
    
    [self.searchBar setImage:[UIImage imageNamed:@"search_normal.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchfield.png"] forState:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"search_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"search_bg.png"]];
    [self.searchBar setFrame:CGRectMake(0, 0, self.searchBar.frame.size.width, 50)];
    UITextField *txtSearchField = [self.searchBar valueForKey:@"_searchField"];
    txtSearchField.font = DEFAULT_REGULAR_FONT(14);
    txtSearchField.textColor=kDEFAULT_TEXT_COLOR;
    [txtSearchField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.tasksTable registerNib:[UINib nibWithNibName:@"FLTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FLTaskCell"];
    
    [self showBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showBanner
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *bannerShownFlag = [defaults objectForKey:@"bannerShown"];
    if (bannerShownFlag) {
        return;
    }
    
    [defaults setObject:@(YES) forKey:@"bannerShown"];
    [defaults synchronize];
    
    FLBannerViewController *bannerController = [self.storyboard instantiateViewControllerWithIdentifier:@"FLBannerViewController"];
    [self presentViewController:bannerController animated:YES completion:nil];
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
            if (![FLInternetConnectionUtils isConnectedToInternet]) {
                cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
                }
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self showErrorNetworkDisabled];
            } else if (![FLInternetConnectionUtils isWebSiteUp]) {
                cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
                }
                
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [self showErrorServerDontRespond];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle] loadNibNamed:loadingCellIdentifier owner:nil options:nil][0];
                }
                cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if(self.EmptySearch.hidden==NO) {
                    [self.EmptySearch setHidden:YES];
                    [self.tasksTable setScrollEnabled:YES];
                    [UIView transitionWithView:self.EmptySearch
                                      duration:0.2
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:NULL
                                    completion:NULL];
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FLHTTPClient sharedClient] getTasksWithCategories:self.selectedCategories query:searchQuery page:page++
					success:^(NSArray *objects, BOOL *stop) {
						BOOL stopValue = *stop;
                        dispatch_async(dispatch_get_main_queue(), ^{
							stopSearch = stopValue;
                            [self.tasks addObjectsFromArray:objects];
                            [self.tasksTable reloadData];
                            
                            if (self.tasks.count==0) {
                                [self.EmptySearch setHidden:NO];
                                [self.tasksTable setScrollEnabled:NO];
                                [UIView transitionWithView:self.EmptySearch
                                                  duration:0.2
                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                animations:NULL
                                                completion:NULL];

                            }
                        });
                    }
                     
                     
					failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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


-(void)search {
    searchQuery = self.searchBar.text;

    self.tasks = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.tasksTable reloadData];
}


- (void)viewDidUnload {
    [self setClearView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}


#pragma mark - Search Bar delegate methods
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar setText:@""];
    searchBar.showsCancelButton = NO;
    [self.searchBar setImage:[UIImage imageNamed:@"search_normal.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
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
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        [cancelButton setTitle:@"Отменить" forState:UIControlStateNormal];
        [[cancelButton titleLabel] setFont:DEFAULT_REGULAR_FONT(16)];        
    }
    [self.searchBar setImage:[UIImage imageNamed:@"search_active.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

@end
