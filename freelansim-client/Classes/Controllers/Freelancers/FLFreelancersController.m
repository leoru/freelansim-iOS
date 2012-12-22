//
//  FLFreelancersController.m
//  freelansim-client
//
//  Created by Кирилл on 22.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLFreelancersController.h"
#import "UIImageView+WebCache.h"

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
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    self.freelancersTable.delegate = self;
    self.freelancersTable.dataSource = self;
    
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
            
            [[FLHTTPClient sharedClient] getFreelancersWithCategories:self.selectedCategories page:page++ success:^(NSArray *objects, AFHTTPRequestOperation *operation, id responseObject, BOOL *stop) {
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
        
//        priceLabel.layer.cornerRadius = 5.0f;
//        priceLabel.backgroundColor = [UIColor colorWithRed:0.96f green:0.87f blue:0.66f alpha:1.00f];
//        priceLabel.layer.borderColor = [UIColor colorWithRed:0.66f green:0.44f blue:0.09f alpha:1.00f].CGColor;
//        priceLabel.textColor = [UIColor colorWithRed:0.26f green:0.29f blue:0.32f alpha:1.00f];
//        priceLabel.layer.borderWidth = 1.0f;
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
    backgroundView.backgroundColor = [UIColor colorWithRed:0.96f green:0.58f blue:0.35f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    selectedTask = self.tasks[indexPath.row];
//    [self performSegueWithIdentifier:@"FreelancerSegue" sender:self];
//    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeGradient];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
//        FLTaskController *taskController = [segue destinationViewController];
//        taskController.task = selectedTask;
    } else if ([segue.identifier isEqualToString:@"FreelancersCategoriesSegue"]) {
        FLCategoriesController *categoriesController = [segue destinationViewController];
        categoriesController.delegate = self;
        categoriesController.selectedCategories = self.selectedCategories;
    }
}



-(void)categoriesDidSelected:(NSArray *)categories {
    self.selectedCategories = categories;
    self.freelancers = [NSMutableArray array];
    stopSearch = NO;
    page = 1;
    [self.freelancersTable reloadData];
}
@end
