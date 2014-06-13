//
//  KnowledgeBaseNavigationViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/21.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "KnowledgeBaseNavigationViewController.h"

@interface KnowledgeBaseNavigationViewController ()

@end

@implementation KnowledgeBaseNavigationViewController

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

- (BOOL)shouldAutorotate
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    //表示しているViewControllerにまかせる
    return [self.visibleViewController supportedInterfaceOrientations];
}

@end
