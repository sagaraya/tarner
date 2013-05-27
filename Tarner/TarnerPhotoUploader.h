//
//  TarnerPhotoUploader.h
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/14.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface TarnerPhotoUploader : NSObject <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}
- (TarnerPhotoUploader *)initWithView:(UIView *)view;
- (void)uploadPhoto:(UIImage *)photo;
@end
