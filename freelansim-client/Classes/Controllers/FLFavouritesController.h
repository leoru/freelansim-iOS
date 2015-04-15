//
//  FLFavouritesControllerViewController.h
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLManagedFreelancer.h"
#import "FLManagedTask.h"
#import "FavouriteCell.h"

@interface FLFavouritesController : UITableViewController
{
    NSMutableArray *favourites;
    FLManagedFreelancer *selectedFreelancer;
    FLManagedTask *selectedTask;
    BOOL editingMode;
}

@property (weak, nonatomic) IBOutlet UITableView *favouritesTable;
@property (strong) FavouriteCell *prototypeCell;

@end
