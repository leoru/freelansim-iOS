//
//  FLFavouritesControllerViewController.m
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLFavouritesController.h"
#import "FLValueTransformer.h"
#import "FLTaskController.h"
#import "FLManagedTask.h"
#import "FLFreelancerController.h"
#import "SVProgressHUD.h"
#import "FavouriteCell.h"

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
    if(editingMode){
        [self.favouritesTable setEditing:NO animated:NO];
        editingMode = NO;
    }
    [self prepareObjects];
    [self initUI];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    favourites = [[NSMutableArray alloc] init];
    [UIRender renderNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    [self.favouritesTable registerNib:[UINib nibWithNibName:@"FavouriteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FavouriteCell"];
}
- (void) viewDidUnload
{
    favourites = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    
    if([favourites count] == 0){
        editingMode = NO;
        [self.favouritesTable setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    UIBarButtonItem *item;
    if(!editingMode)
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(performRightItem:)];
    else
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(performRightItem:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)performRightItem:(id)sender{
    if(!editingMode){
        [self.favouritesTable setEditing:YES animated:YES];
    }
    else{
        [self.favouritesTable setEditing:NO animated:YES];
    }
    editingMode = !editingMode;
    [self initUI];
}

-(void)prepareObjects{
    NSArray *freelancers = [FLManagedFreelancer MR_findAll];
    NSArray *tasks = [FLManagedTask MR_findAll];
    
    NSArray *both = [freelancers arrayByAddingObjectsFromArray:tasks];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date_create" ascending:NO];
    NSArray *sortingDescriptors = [NSArray arrayWithObject:descriptor];
    favourites =[NSMutableArray arrayWithArray:[both sortedArrayUsingDescriptors:sortingDescriptors]];
    [self.favouritesTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favourites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FavouriteCell";
    FavouriteCell *cell = (FavouriteCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    id obj = [favourites objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[FLManagedFreelancer class]]) {
        FLManagedFreelancer *freelancer = (FLManagedFreelancer *)obj;
        [cell setFreelancer:freelancer];
    } else if([obj isKindOfClass:[FLManagedTask class]]) {
        FLManagedTask *task = (FLManagedTask *)obj;
        [cell setTask:task];
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.99f green:0.51f blue:0.33f alpha:1.00f];
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        id obj = favourites[indexPath.row];
        if ([obj isKindOfClass:[FLManagedFreelancer class]]) {
            FLManagedFreelancer *freelancer = (FLManagedFreelancer *)obj;
            [freelancer MR_deleteEntity];
            
        } else {
            if([obj isKindOfClass:[FLManagedTask class]]){
                FLManagedTask *task = (FLManagedTask *)obj;
                [task MR_deleteEntity];
            }else return;
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
            
        }];
        [favourites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
    [tableView endUpdates];
    [self initUI];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = favourites[indexPath.row];
    if([obj isKindOfClass:[FLManagedFreelancer class]]){
        selectedFreelancer = (FLManagedFreelancer *)obj;
        [self performSegueWithIdentifier:@"FreelancerSegue" sender:self];
    }else if([obj isKindOfClass:[FLManagedTask class]]){
        selectedTask = (FLManagedTask *)obj;
        [self performSegueWithIdentifier:@"TaskSegue" sender:self];
    }
    [SVProgressHUD showWithStatus:@"Загрузка..." maskType:SVProgressHUDMaskTypeGradient];
}

#pragma mark - Prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FreelancerSegue"]) {
        FLFreelancerController *freelancerController = [segue destinationViewController];
        FLFreelancer *freelancer = [[FLFreelancer alloc] init];
        [freelancer mappingWithManagedFreelancer:selectedFreelancer];
        freelancerController.freelancer = freelancer;
    } else if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        FLTaskController *taskController = [segue destinationViewController];
        FLTask *task = [[FLTask alloc] init];
        [task mapFromManagedTask:selectedTask];
        taskController.task = task;
    }
}

@end
