//
//  KnowledgeBaseEditorRoomViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/07/13.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeBaseEditorRoomViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
- (IBAction)pushRightButton:(UIBarButtonItem *)sender;

@end
