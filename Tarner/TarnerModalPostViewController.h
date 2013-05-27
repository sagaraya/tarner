//
//  TarnerModalPostViewController.h
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TarnerModalPostViewControllerDelegate <NSObject>
- (void)hideModalPostView;
@end

@interface TarnerModalPostViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate>
@property (strong, nonatomic) id <TarnerModalPostViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *parentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
- (IBAction)pressPostButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;

- (id)initWithPhoto:(UIImage *)photo withDelegate:(id <TarnerModalPostViewControllerDelegate>)delegate;
@end
