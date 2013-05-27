//
//  TarnerMyPageViewController.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Parse/Parse.h>

#import "TarnerMyPageViewController.h"
#import "TarnerPhotoCollectionViewCell.h"

@interface TarnerMyPageViewController ()
@property(strong, nonatomic) NSArray *photos;
@end

@implementation TarnerMyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"マイページ";
        self.tabBarItem.image = [UIImage imageNamed:@"user"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query orderByAscending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *images, NSError *error) {
        if (!error) {
            _photos = images; // dataSourceとか設定する前にセットしとかないとダメ
            [_photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"]; //_photoCollectionViewがweakだからdelegateと同じスコープじゃないとだめ？
            _photoCollectionView.dataSource = self;
            _photoCollectionView.delegate = self;
            //初回読み込み、dataSourceを変えたタイミング、reloadDataのタイミングでdataSourceやdelegateのメソッドが呼ばれる
        }
    }];
}


#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PFFile *theImage = [_photos[indexPath.row] objectForKey:@"imageFile"];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 70, 70);
        [cell addSubview:imageView];

        dispatch_async(dispatch_get_main_queue(), ^{
            [cell addSubview:imageView];
        });
    });

    return cell;
}

@end
