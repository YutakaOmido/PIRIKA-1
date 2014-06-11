//
//  KnowledgeBaseEditorViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface KnowledgeBaseEditorViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *kbEditor;
- (IBAction)pushButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButton;
-(void)setFileName;
@end
