//
//  SettingDetailViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/07/03.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingDetailViewController : UITableViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>
- (void)setMasterIndexPath:(NSIndexPath *)path;
@end
