//
//  TarnerMyPageViewController.h
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TarnerMyPageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end
