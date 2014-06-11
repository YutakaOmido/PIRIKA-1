//
//  RoomRootNavigationViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/24.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "RoomRootNavigationViewController.h"

@interface RoomRootNavigationViewController ()

@end

@implementation RoomRootNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[viewController viewDidAppear:animated];
}

- (BOOL)shouldAutorotate
{
    //表示しているViewControllerにまかせる
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController supportedInterfaceOrientations];
}
@end
