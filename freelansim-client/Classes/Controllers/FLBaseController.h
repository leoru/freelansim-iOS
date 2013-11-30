//
//  FLBaseController.h
//  freelansim-client
//
//  Created by Кирилл on 16.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBaseController : UIViewController

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

-(void)showErrorNetworkDisabled;

-(void)showErrorServerDontRespond;

@end
