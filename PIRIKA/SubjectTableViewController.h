//
//  SubjectTableViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SubjectTableViewController : UITableViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *subjectTable;

@end
