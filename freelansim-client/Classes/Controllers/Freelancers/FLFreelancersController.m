//
//  FLFreelancersController.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancersController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "FLFreelancerController.h"

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
    searchQuery = @"";
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    self.freelancersTable.delegate = self;
    self.freelancersTable.dataSource = self;
    self.searchBar.delegate = self;
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    self.freelancersTable.backgroundColor = [UIColor clearColor];
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
    return self.freelancers.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FLFreelancerCell";
    static NSString *loadingCellIdentifier = @"LoadingCell";
    static NSString *emptyCellIdentifier = @"FLEmptyCell";
    UITableViewCell *cell;
    
    
    if (indexPath.row == self.freelancers.count) {
        if (!stopSearch) {
            cell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:loadingCellIdentifier owner:nil options:nil][0];
            }
            
            [[FLHTTPClient sharedClient] getFreelancersWithCategories:self.selectedCategories query:searchQuery page:page++ success:^(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    stopSearch = *stop;
                    [self.freelancers addObjectsFromArray:objects];
                    [self.freelancersTable reloadData];
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
        
        UILabel *freelancerName = (UILabel *)[cell viewWithTag:1];
        UILabel *freelancerCategory = (UILabel *)[cell viewWithTag:2];
        UILabel *freelancerShortDescription = (UILabel *)[cell viewWithTag:3];
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:4];
        
        UIActivityIndicatorView *loader = (UIActivityIndicatorView *)[cell viewWithTag:10];
        UIImageView *thumb = (UIImageView *)[cell viewWithTag:5];
        thumb.hidden = YES;
        
        FLFreelancer *freelancer = self.freelancers[indexPath.row];
        [thumb setImageWithURL:[NSURL URLWithString:freelancer.thumbPath]  placeholderImage:nil success:^(UIImage *image, BOOL cached) {
            loader.hidden = YES;
            thumb.hidden = NO;
        } failure:^(NSError *error) {
            
        }];
        freelancerName.text = freelancer.name;
        freelancerCategory.text = freelancer.speciality;
        freelancerShortDescription.text = freelancer.desc;
        priceLabel.text = freelancer.price;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.99f green:0.51f blue:0.33f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor greenColor];
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

-(void)search{
    searchQuery = self.searchBar.text;
    stopSearch = NO;
    page = 1;
    self.freelancers = [NSMutableArray array];
    [self.freelancersTable reloadData];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
