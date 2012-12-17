
//  main.m
//  freelansim-client
//
//  Created by Кирилл on 13.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings init];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([KKAppDelegate class]));
    }
}
