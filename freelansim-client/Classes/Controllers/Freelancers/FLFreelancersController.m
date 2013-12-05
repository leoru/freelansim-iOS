//
//  FLFreelancersController.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancersController.h"

#import "SVProgressHUD.h"
#import "FLFreelancerController.h"
#import "FLInternetConnectionUtils.h"
#import "FLFreelancerCell.h"

@interface FLFreelancersController ()

@end

@implementation FLFreelancersController

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
    [self.freelancersTable addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    
    searchQuery = @"";
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    
    self.freelancersTable.delegate = self;
    self.freelancersTable.dataSource = self;
    self.searchBar.delegate = self;
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    self.freelancersTable.backgroundColor = [UIColor clearColor];
    
    [self.freelancersTable registerNib:[UINib nibWithNibName:@"FLFreelancerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FLFreelancerCell"];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setFreelancers:nil];
    [super viewDidUnload];
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
    return self.freelancers.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FLFreelancerCell";
    static NSString *loadingCellIdentifier = @"LoadingCell";
    static NSString *emptyCellIdentifier = @"FLEmptyCell";
    UITableViewCell *cell;
    
    
    if (indexPath.row == self.freelancers.count) {
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
                    [[FLHTTPClient sharedClient] getFreelancersWithCategories:self.selectedCategories query:searchQuery page:page++ success:^(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            stopSearch = *stop;
                            [self.freelancers addObjectsFromArray:objects];
                            [self.freelancersTable reloadData];
                        });
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                });
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:emptyCellIdentifier owner:nil options:nil][0];
            }
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        
        FLFreelancerCell *freelancerCell = (FLFreelancerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        FLFreelancer *freelancer = self.freelancers[indexPath.row];
        [freelancerCell setFreelancer:freelancer];
        cell = freelancerCell;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.88f green:0.54f blue:0.42f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.freelancersTable deselectRowAtIndexPath:indexPath animated:NO];
    selectedFreelancer = self.freelancers[indexPath.row];
    [self performSegueWithIdentifier:@"FreelancerSegue" sender:self];
    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeGradient];
    
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FreelancerSegue"]) {
        FLFreelancerController *freelancerController = [segue destinationViewController];
        freelancerController.freelancer = selectedFreelancer;
    } else if ([segue.identifier isEqualToString:@"FreelancersCategoriesSegue"]) {
        FLCategoriesController *categoriesController = [segue destinationViewController];
        categoriesController.delegate = self;
        categoriesController.selectedCategories = self.selectedCategories;
    }
}

#pragma mark - Select Category Delegate
-(void)categoriesDidSelected:(NSArray *)categories {
    self.selectedCategories = categories;
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.freelancersTable reloadData];
}


#pragma mark - SearchBar Delegate methods
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

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

-(void)refresh {
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.freelancersTable reloadData];
    [refreshControl endRefreshing];
}

-(void)search{
    searchQuery = self.searchBar.text;
    stopSearch = NO;
    page = 1;
    self.freelancers = [NSMutableArray array];
    [self.freelancersTable reloadData];
}

@end
