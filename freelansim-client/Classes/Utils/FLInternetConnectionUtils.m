//
//  FLInternetConnectionUtils.m
//  freelansim
//
//  Created by Daniyar Slahutdinov on 14.01.13.
//  Copyright (c) 2013 Kirill Kunst. All rights reserved.
//

#import "FLInternetConnectionUtils.h"
#import "Reachability.h"

@implementation FLInternetConnectionUtils

+(BOOL)isWebSiteUp{
    Reachability *reachable = [Reachability reachabilityWithHostname:@"freelansim.ru"];
    NetworkStatus networkStatus = [reachable currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+(BOOL)isConnectedToInternet{
    Reachability *reachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachable currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end
