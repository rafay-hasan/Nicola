//
//  User Details.m
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import "User Details.h"

@implementation User_Details

+ (User_Details *) sharedInstance
{
    static dispatch_once_t pred;
    static User_Details *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init
{
    self.membershipId = [NSString new];
    self.membershipId = @"1";
    return self;
}




@end
