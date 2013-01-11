//
//  FLCategoriesController.h
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"

@protocol FLCategoriesDelegate <NSObject>

-(void)categoriesDidSelected:(NSArray *)categories;

@end
@interface FLCategoriesController : FLBaseController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *categories;
}

- (IBAction)checkCategoriesClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *categoriesTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic,retain) id<FLCategoriesDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *selectedCategories;

@end
