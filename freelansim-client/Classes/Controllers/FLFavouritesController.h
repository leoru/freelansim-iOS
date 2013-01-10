//
//  FLFavouritesControllerViewController.h
//  freelansim-client
//
//  Created by Daniyar Salahutdinov on 10.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLFavouritesController : UITableViewController{
    NSMutableArray *favourites;
}

@property (weak, nonatomic) IBOutlet UITableView *favouritesTable;

@end
