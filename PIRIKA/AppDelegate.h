//
//  AppDelegate.h
//  PIRIKA
//
//  Created by katsura on 2014/01/06.
//  Copyright (c) 2014年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary* data;
@end
