//
//  TarnerUser.h
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/14.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TarnerUser : NSObject

+ (TarnerUser *)shared;
- (void)loadOrCreateUser;

@property(strong, nonatomic) PFUser *user;
@end
