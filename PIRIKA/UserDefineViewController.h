//
//  UserDefineViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/08/28.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefineViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
- (IBAction)pushRightButton:(UIBarButtonItem *)sender;
- (id)initWithText:(NSString *)str;
@end
