//
//  FLRefrashControl.h
//  freelansim
//
//  Created by Ivan Morozov on 13.05.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLRefreshControl : UIRefreshControl {
    
}

@property (strong,nonatomic) UIImageView *loadIndicator;
@property (strong) UIView *refreshLoadingView;

- (void)Pull;
-(void) Setup;
@end
