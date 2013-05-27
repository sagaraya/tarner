//
//  TarnerUser.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/14.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Parse/Parse.h>

#import "TarnerUser.h"

@implementation TarnerUser

static TarnerUser *instance;

+ (TarnerUser *)shared
{
    if (!instance) {
        instance = [[TarnerUser alloc] init];
    }
    return instance;
}

- (void)loadOrCreateUser
{
    _user = [PFUser currentUser];
    if (!_user) {
        // Dummy username and password
        _user = [PFUser user];
        _user.username = @"Matt";
        _user.password = @"password";
        _user.email = @"Matt@example.com";

        [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                // Assume the error is because the user already existed.
                [PFUser logInWithUsername:@"Matt" password:@"password"];
            }
        }];
    }
}
@end
