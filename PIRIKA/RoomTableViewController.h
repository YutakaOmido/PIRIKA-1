//
//  RoomTableViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/07/11.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTableViewController : UITableViewController<UIAlertViewDelegate>
- (IBAction)pushRightButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@end
