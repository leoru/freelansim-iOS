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
    page = 1;
    self.tasksTable.delegate = self;
    self.tasksTable.dataSource = self;
    self.tasksTable.backgroundColor = [UIColor clearColor];
    self.clearView.backgroundColor = [UIColor patternBackgroundColor];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
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
                
                [[FLHTTPClient sharedClient] getTasksWithCategories:self.selectedCategories page:page++ success:^(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        stopSearch = *stop;
                        [self.tasks addObjectsFromArray:objects];
                        [self.tasksTable reloadData];
                    });
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self showErrorNetworkDisabled];
                }];
            }
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
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:4];
         UILabel *publishedLabel = (UILabel *)[cell viewWithTag:7];
        
        priceLabel.layer.cornerRadius = 5.0f;
        priceLabel.backgroundColor = PriceLabelBackgroundColor;
        priceLabel.layer.borderColor = PriceLabelBorderColor;
        priceLabel.textColor = PriceLabelTextColor;
        
        priceLabel.layer.borderWidth = 1.0f;
        FLTask *task = self.tasks[indexPath.row];
        taskTitle.text = task.title;
        taskCategory.text = task.category;
        taskShortDescription.text = task.shortDescription;
        priceLabel.text = task.price;
        [priceLabel sizeToFit];
        
        CGRect frame = priceLabel.frame;
        frame.size.height += 5;
        frame.size.width += 5;
        priceLabel.frame = frame;
        
        publishedLabel.text = task.published;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.99f green:0.51f blue:0.33f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
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
        categoriesController.selectedCategories = self.selectedCategories;
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
    [super viewDidUnload];
}
@end
