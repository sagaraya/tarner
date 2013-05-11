//
//  TarnerSecondViewController.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import "TarnerSecondViewController.h"

@interface TarnerSecondViewController ()

@end

@implementation TarnerSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
