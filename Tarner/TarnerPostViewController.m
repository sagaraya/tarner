//
//  TarnerPostViewController.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import "TarnerPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TarnerModalPostViewController.h"

@interface TarnerPostViewController ()
@property(strong, nonatomic) TarnerModalPostViewController *modalPostVC;
@end

@implementation TarnerPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"投稿";
        self.tabBarItem.image = [UIImage imageNamed:@"upload-photo"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// だいぶ無理矢理感あってよくない実装。tabbarを自前で実装すればちゃんと選んだイベントがとれるはず
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.delegate = nil;
}

- (void)showModalPostViewWithPhoto:(UIImage *)photo
{
    _modalPostVC = [[TarnerModalPostViewController alloc] initWithPhoto:photo withDelegate:(id <TarnerModalPostViewControllerDelegate>)self];
    [self presentViewController:_modalPostVC animated:YES completion:nil];
}

- (void)hideModalPostView
{
    [_modalPostVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self showActionSheetFromTabBar:self.tabBarController.tabBar usingDelegate:(id <UIActionSheetDelegate>)self];
}

#pragma mark -
#pragma mark ActionSheet
- (void)showActionSheetFromTabBar:(UITabBar *)tabBar usingDelegate:(id <UIActionSheetDelegate>)delegate
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = delegate;
    actionSheet.title = @"写真を投稿します";
    [actionSheet addButtonWithTitle:@"ライブラリから選択"];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"カメラで撮影"];
        actionSheet.cancelButtonIndex = 2;
    } else {
        actionSheet.cancelButtonIndex = 1;
    }
    [actionSheet addButtonWithTitle:@"キャンセル"];
    [actionSheet showFromTabBar:tabBar];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    switch (buttonIndex) {
        case 0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        case 1:
            NSLog(@"%d", actionSheet.cancelButtonIndex);
            if (actionSheet.cancelButtonIndex == 1) { break; }
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        default:
            break;
    }
}


# pragma mark -
# pragma mark UIImagePickerControllerDelegate
// cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// save
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;

    // 静止画像のキャプチャを処理する
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
    }

    // カメラロールに保存
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil , nil);
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [self showModalPostViewWithPhoto:imageToSave];
    }];
}


@end
