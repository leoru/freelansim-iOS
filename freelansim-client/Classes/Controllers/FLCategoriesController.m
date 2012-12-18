//
//  FLCategoriesController.m
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLCategoriesController.h"
#import "FLCategory.h"

@interface FLCategoriesController ()

@end

@implementation FLCategoriesController

@synthesize selectedCategories = _selectedCategories;

-(NSMutableArray *)selectedCategories {
    if (!_selectedCategories)
        _selectedCategories = [NSMutableArray array];
    return _selectedCategories;
}

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
    self.navItem.title = @"Разделы";
    categories = [FLCategory categories];
    
    self.categoriesTable.delegate = self;
    self.categoriesTable.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavItem:nil];
    [self setCategoriesTable:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CategoryCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil][0];
    }
    
    UILabel *categoryTitle = (UILabel *)[cell viewWithTag:1];
    
    FLCategory *category = categories[indexPath.row];
    
    categoryTitle.text = category.title;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.33f green:0.71f blue:0.92f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.categoriesTable cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [self.categoriesTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [self.categoriesTable deselectRowAtIndexPath:indexPath animated:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    FLCategory *category = categories[indexPath.row];
    if ([self.selectedCategories containsObject:category]) {
        [self.selectedCategories removeObject:category];
    } else {
        [self.selectedCategories addObject:category];
    }
    
    
}

- (IBAction)checkCategoriesClick:(id)sender {
    [self.delegate categoriesDidSelected:self.selectedCategories];
    [self dismissModalViewControllerAnimated:YES];
}



@end
