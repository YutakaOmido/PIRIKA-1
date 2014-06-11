//
//  ArgumentRoomViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/08/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArgumentRoomViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *subject;
@property (weak, nonatomic) IBOutlet UIImageView *user0;
@property (weak, nonatomic) IBOutlet UIImageView *user1;
@property (weak, nonatomic) IBOutlet UIImageView *user2;
@property (weak, nonatomic) IBOutlet UIImageView *user3;
@property (weak, nonatomic) IBOutlet UIImageView *user4;
@property (weak, nonatomic) IBOutlet UIImageView *user5;
@property (weak, nonatomic) IBOutlet UIImageView *user6;
@property (weak, nonatomic) IBOutlet UIImageView *user7;
@property (weak, nonatomic) IBOutlet UIImageView *user8;
- (IBAction)touchButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *user9;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@end
