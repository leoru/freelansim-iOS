//
//  FLFavouritesControllerViewController.m
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFavouritesController.h"
#import "FLManagedFreelancer.h"
#import "FLValueTransformer.h"

@interface FLFavouritesController ()

@end

@implementation FLFavouritesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self prepareObjects];
    [super viewWillAppear:animated];
}

-(void)prepareObjects{
    NSArray *freelancers = [FLManagedFreelancer MR_findAll];
    //and for tasks
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date_create" ascending:YES];
    NSArray *sortingDescriptors = [NSArray arrayWithObject:descriptor];
    favourites =[NSMutableArray arrayWithArray:[freelancers sortedArrayUsingDescriptors:sortingDescriptors]];
    [self.favouritesTable reloadData];
}

- (void)viewDidLoad
{
    favourites = [[NSMutableArray alloc] init];
    [UIRender renderNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidUnload{
    favourites = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [favourites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLValueTransformer *transformer = [[FLValueTransformer alloc] init];
    static NSString *cellIdentifier = @"FavouriteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil][0];
    }
    FLManagedFreelancer *freelancer = [favourites objectAtIndex:indexPath.row];
    // Configure the cell...
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = (UIImage *)[transformer reverseTransformedValue:freelancer.avatar];
    
    UILabel *name = (UILabel *)[cell viewWithTag:2];
    name.text = freelancer.name;
    
    UILabel *speciality = (UILabel *)[cell viewWithTag:3];
    speciality.text = freelancer.speciality;
    
    UILabel *desc = (UILabel *)[cell viewWithTag:4];
    desc.text = freelancer.desc;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
