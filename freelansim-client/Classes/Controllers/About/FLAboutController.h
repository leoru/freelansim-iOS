//
//  FLAboutController.h
//  freelansim-client
//
//  Created by Developer on 11.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLBaseController.h"

@interface FLAboutController : FLBaseController

@property (weak, nonatomic) IBOutlet UIButton *mailButton;

- (IBAction)sendMail:(id)sender;

@end
