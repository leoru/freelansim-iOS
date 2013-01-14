//
//  FLAboutController.m
//  freelansim-client
//
//  Created by Developer on 11.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLAboutController.h"
#import "UIRender.h"

@interface FLAboutController ()

@end

@implementation FLAboutController

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
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    [UIRender renderMailButton:self.mailButton];
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMailButton:nil];
    [super viewDidUnload];
}
- (IBAction)sendMail:(id)sender {
    NSURL *url = [NSURL URLWithString:crtwebMailString];
    [[UIApplication sharedApplication] openURL:url];
}
@end
