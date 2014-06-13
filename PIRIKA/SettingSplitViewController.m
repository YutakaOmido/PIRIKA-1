//
//  SettingSplitViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/02.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "SettingSplitViewController.h"
#import "SettingMasterViewController.h"
#import "SettingDetailViewController.h"

@interface SettingSplitViewController ()
{
}
@end

@implementation SettingSplitViewController
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    NSArray *viewControllers = self.viewControllers;
    UINavigationController *view0 = [viewControllers objectAtIndex:0];
    SettingMasterViewController *master = (SettingMasterViewController *)view0.topViewController;
    UINavigationController *view1 = [viewControllers objectAtIndex:1];
    id detail = view1.topViewController;
    [master setDetailViewContoller:detail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 回転ごとの処理
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
@end
