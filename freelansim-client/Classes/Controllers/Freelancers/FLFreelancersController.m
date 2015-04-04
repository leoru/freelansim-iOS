//
//  FLFreelancersController.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancersController.h"
#import "FLFreelancerController.h"
#import "FLFreelancerCell.h"
#import "FLInternetConnectionUtils.h"
#import "SVProgressHUD.h"


@interface FLFreelancersController ()
@property (weak, nonatomic) IBOutlet UIView *EmptySearch;
@end


@implementation FLFreelancersController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [self.freelancersTable addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    
    searchQuery = @"";
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    
    UIEdgeInsets edges;
    edges.left = 10;
    edges.right = 10;
    self.freelancersTable.separatorInset = edges;
    self.freelancersTable.delegate = self;
    self.freelancersTable.dataSource = self;
    self.searchBar.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.freelancersTable.backgroundColor = [UIColor clearColor];
    
    [self.searchBar setImage:[UIImage imageNamed:@"search_normal.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchfield.png"] forState:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"search_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"search_bg.png"]];

    
    [self.freelancersTable registerNib:[UINib nibWithNibName:@"FLFreelancerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FLFreelancerCell"];
}


- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setFreelancers:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
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
                    [self.freelancersTable setScrollEnabled:YES];
                    [UIView transitionWithView:self.EmptySearch
                                      duration:0.2
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:NULL
                                    completion:NULL];
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FLHTTPClient sharedClient] getFreelancersWithCategories:self.selectedCategories query:searchQuery page:page++
					success:^(NSArray *objects, BOOL *stop) {
						BOOL stopValue = *stop;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            stopSearch = stopValue;
                            [self.freelancers addObjectsFromArray:objects];
                            [self.freelancersTable reloadData];
                            
                            if (self.freelancers.count==0) {
                                [self.EmptySearch setHidden:NO];
                                [self.freelancersTable setScrollEnabled:NO];
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
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        
        FLFreelancerCell *freelancerCell = (FLFreelancerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        FLFreelancer *freelancer = self.freelancers[indexPath.row];
        [freelancerCell setFreelancer:freelancer];
        cell = freelancerCell;
    }
    
    

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
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
        categoriesController.selectedCategories = [self.selectedCategories mutableCopy];
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self search];
    [self.searchBar resignFirstResponder];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self search];
        [self.searchBar resignFirstResponder];
    }
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [self.searchBar setImage:[UIImage imageNamed:@"search_normal.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [self search];
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


-(void)refresh {
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.freelancersTable reloadData];

	[refreshControl endRefreshing];
}


-(void)search {
    searchQuery = self.searchBar.text;

	self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.freelancersTable reloadData];
}

@end
