//
//  KnowledgeBaseTableViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/06/06.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface KnowledgeBaseTableViewController : UITableViewController
- (void)readFile:(NSString *)fileName;
- (IBAction)downloadFile:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@end
