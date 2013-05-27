//
//  TarnerPhotoUploader.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/14.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Parse/Parse.h>

#import "TarnerPhotoUploader.h"
#import "TarnerUser.h"
#import "MBProgressHUD.h"

@interface TarnerPhotoUploader()
@property(strong, nonatomic) UIView *view;
@end

@implementation TarnerPhotoUploader

- (TarnerPhotoUploader *)initWithView:(UIView *)view
{
    _view = view;
    return self;
}

- (void)uploadPhoto:(UIImage *)photo
{
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.05f);

    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];

    // show loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [_view addSubview:HUD];

    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];

    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];

            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:_view];
            [_view addSubview:HUD];

            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;

            HUD.delegate = self;
            [HUD show:YES];

            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];

            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[TarnerUser shared].user];

            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];

            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [HUD hide:YES];
                    //[self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate Methods 
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
