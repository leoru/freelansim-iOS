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
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    self.categoriesTable.backgroundColor = [UIColor clearColor];
    self.navBar.tintColor = [UIColor colorWithRed:0.97f green:0.67f blue:0.44f alpha:1.00f];
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
    [self setNavBar:nil];
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
    backgroundView.backgroundColor = [UIColor colorWithRed:0.99f green:0.51f blue:0.33f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    
    for (FLCategory *cat in self.selectedCategories) {
        if ([cat.title isEqualToString:category.title]) {
            [self.categoriesTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewRowAnimationNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.categoriesTable cellForRowAtIndexPath:indexPath];
    [self.categoriesTable deselectRowAtIndexPath:indexPath animated:YES];
    cell.accessoryType = UITableViewCellAccessoryNone;
    FLCategory *category = categories[indexPath.row];
    
    for (FLCategory *cat in [self.selectedCategories copy]) {
        if ([cat.title isEqualToString:category.title]) {
            [self.selectedCategories removeObject:cat];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.categoriesTable cellForRowAtIndexPath:indexPath];
    
    [self.categoriesTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    FLCategory *category = categories[indexPath.row];
    
    [self.selectedCategories addObject:category];
    
    
}

#pragma mark - Clickers
- (IBAction)checkCategoriesClick:(id)sender {
    [self.delegate categoriesDidSelected:self.selectedCategories];
    [self dismissModalViewControllerAnimated:YES];
}

@end
