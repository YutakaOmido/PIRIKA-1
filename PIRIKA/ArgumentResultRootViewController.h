//
//  ArgumentResultRootViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/06/25.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTCPConnection.h"

@interface ArgumentResultRootViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIPopoverControllerDelegate,UITableViewDelegate,UIAlertViewDelegate>
- (void)pushRightButton;
@end
