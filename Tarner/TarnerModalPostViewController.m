//
//  TarnerModalPostViewController.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TarnerModalPostViewController.h"
#import "TarnerPhotoUploader.h"

@interface TarnerModalPostViewController ()
@property(strong, nonatomic) UIImage *photo;
@property(strong, nonatomic) UITapGestureRecognizer *singleTap;
@end

@implementation TarnerModalPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhoto:(UIImage *)photo withDelegate:(id <TarnerModalPostViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _photo = photo;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _parentScrollView.scrollEnabled = YES;

    _photoView.image = _photo;
    _descriptionView.layer.borderWidth = 1;
    _descriptionView.layer.borderColor = [[UIColor grayColor] CGColor];
    _descriptionView.layer.cornerRadius = 8;
    _descriptionView.delegate = (id <UITextViewDelegate>)self;

    [self addKeyboardHelper];
}

# pragma mark -
# pragma mark keyboard
- (void)addKeyboardHelper
{
    // register hide keyboard gesture
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    _singleTap.delegate = (id <UIGestureRecognizerDelegate>)self;
    _singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_singleTap];

    // add keyboard notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/* keyboard以外の場所をタップしたらキーボードを隠す */
- (void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [_descriptionView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == _singleTap) {
        // キーボード表示中のみ有効
        return (_descriptionView.isFirstResponder ? YES : NO);
    }
    return YES;
}

static BOOL isKeyboardShown = NO;
- (void)keyboardWillShow:(NSNotification *)notification
{
    isKeyboardShown = YES;

    // キーボードの表示完了時の場所と大きさを取得。
    CGRect keyboardFrameEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardHeight = keyboardFrameEnd.size.height;

    _parentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width + keyboardHeight);

    [_parentScrollView setContentOffset:CGPointMake(0, keyboardHeight) animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isKeyboardShown = NO;
    [_parentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


# pragma mark -
# pragma mark header buttons
- (IBAction)pressPostButton:(id)sender {
    TarnerPhotoUploader *photoUploader = [[TarnerPhotoUploader alloc] initWithView:self.view];
    [photoUploader uploadPhoto:_photo];
}

- (IBAction)pressCancelButton:(id)sender {
    if (isKeyboardShown) {
        [_descriptionView resignFirstResponder];
        return;
    }

    if (_delegate && [_delegate respondsToSelector:@selector(hideModalPostView)]) {
        [_delegate hideModalPostView];
    }
}
@end
