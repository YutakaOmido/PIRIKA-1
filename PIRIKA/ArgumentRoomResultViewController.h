//
//  ArgumentRoomResultViewController.h
//  PIRIKA
//
//  Created by katsura on 2014/01/07.
//  Copyright (c) 2014年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArgumentResultViewController.h"

@interface ArgumentRoomResultViewController : ArgumentResultViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIPopoverControllerDelegate,UITableViewDelegate,UIAlertViewDelegate>
- (IBAction)pushRightButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
- (IBAction)pushLeftButton:(UIBarButtonItem *)sender;

 
@end
