//
//  SettingDetailViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/03.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "SettingDetailViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"

@interface SettingDetailViewController ()
{
    NSIndexPath *_masterIndexPath;
    NSArray *_nameItem;
    NSArray *_nameSection;
    NSArray *_networkItem;
    NSArray *_networkSection;
    NSArray *_truthValue;
    NSArray *_truthValueDetail;
    UIPopoverController *_popover;
    UIImage *_personal;
//    UIBarButtonItem *_rightButton;
    AppDelegate *_appDelegate;
    UITextField *_tf;
}
@end

@implementation SettingDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 40)];;
    _tf.delegate = self;
    _tf.returnKeyType = UIReturnKeyDone;
    _tf.tag = 0;
    _tf.text =[_appDelegate.data objectForKey:@"userName"];
    _nameItem     = [NSArray arrayWithObjects: _tf,
                      nil];
    _nameSection =  [NSArray arrayWithObjects: @"Name",
                     @"Image",
                     nil];
    _networkSection = [NSArray arrayWithObjects:@"IP",
                                                @"port",
                                                nil];
    UITextField *ipField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 40)];;
    ipField.delegate = self;
    ipField.returnKeyType = UIReturnKeyDone;
    ipField.tag = 1;
    ipField.text =[_appDelegate.data objectForKey:@"ip"];
    ipField.placeholder = @"pirika.cs.ie.niigata-u.ac.jp";
    
    UITextField *portField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 40)];;
    portField.delegate = self;
    portField.returnKeyType = UIReturnKeyDone;
    portField.tag = 2;
    portField.text =[_appDelegate.data objectForKey:@"port"];
    portField.placeholder = @"51984";
    _networkItem = [NSArray arrayWithObjects:   ipField,
                                                portField,
                                                nil];
    _truthValue = [NSArray arrayWithObjects:@"01value",
                                            @"2Value",
                                            @"4Value",
                                            @"7Value",
                                            @"IntValue",
                                            nil];
    _truthValueDetail = [NSArray arrayWithObjects:@"Annotation is range of real number from 0 to 1.",
                         @"Anottation is 1.0.",
                         @"Anottation is top, true, false or bot.",
                         @"Anottation is fit, it, fi, ft, t, i or f.",
                         @"Anottation is range of real number.",
                         nil];
    
    /*
    _rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                 target:self
                                                                 action:@selector(pushRightButton:)];
    self.navigationItem.rightBarButtonItem = _rightButton;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (_masterIndexPath.section) {
        case 0:
            return [_nameSection count];
            break;
        case 1:
            return [_networkSection count];
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_masterIndexPath.section) {
        case 0:
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 1;
                default:
                    break;
            }
            break;
        case 1:
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 1;
                    break;
                default:
                    break;
            }
        case 2:
            return [_truthValue count];
        default:
            break;
    }
    return 0;
}

// セクション名を返す.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (_masterIndexPath.section) {
        case 0:
            switch (_masterIndexPath.row) {
                case 0:
                    return (NSString *)[_nameSection objectAtIndex:section];
                    break;
                case 1:
                    return @"Image";
                default:
                    break;
            }
            break;
        case 1:
            return (NSString *)[_networkSection objectAtIndex:section];
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Detail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    // 文字が重ならないよう
    // 一旦以前のサブビューを取り除く
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (_masterIndexPath.section) {
        case 0:
            switch (indexPath.section) {
                case 0:
                    [cell.contentView addSubview:[_nameItem objectAtIndex:0]];
                    break;
                case 1:
                    cell.textLabel.text = @"Personal Image";
                    _personal = [self loadImage:@"self.jpg"];
                    
                    if (_personal!=nil) {
                        cell.imageView.image = _personal;
                    }else{
                        _personal = [UIImage imageNamed:@"user1.png"];
                        cell.imageView.image = _personal;
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.section) {
                case 0:
                    [cell.contentView addSubview:[_networkItem objectAtIndex:0]];
                    break;
                case 1:
                    [cell.contentView addSubview:[_networkItem objectAtIndex:1]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //セルの情報の中から文字列を取り出す
    if (_masterIndexPath.section==0 && indexPath.section==1 && indexPath.row==0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setAllowsEditing:YES];
            [imagePickerController setDelegate:self];
            
            //[self presentViewController:imagePickerController animated:YES completion:nil];
            // iPadの場合はUIPopoverControllerを使う
            _popover = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
//            [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [_popover presentPopoverFromRect:CGRectMake(0, 0, 400, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            NSLog(@"photo library invalid.");
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
}

// キーボードを隠す.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// 文字列を取得.
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    NSString *str = textField.text;
    switch (textField.tag) {
        case 0:
            // 禁止文字を削除
            str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@";" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"|" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"*" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"?" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
            textField.text = str;
            [self setDataBox:str :@"userName"];
            break;
        case 1:
            [self setDataBox:str :@"ip"];
            break;
        case 2:
            [self setDataBox:str :@"port"];
            break;
        default:
            break;
    }
    
    
}

// AppDelegate の NSMutableData に保存.
- (void)setDataBox:(NSObject *)value :(NSString *)key
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:value forKey:key];
}

- (void)setMasterIndexPath:(NSIndexPath *)path
{
    _masterIndexPath = path;
}

// 写真撮影後、もしくはフォトライブラリでサムネイル選択後に呼ばれるDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// オリジナル画像
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	// 編集画像
	UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
	UIImage *saveImage;
	
	if(editedImage)
	{
		saveImage = editedImage;
	}
	else
	{
		saveImage = originalImage;
	}
	
	// UIImageViewに画像を設定
    _personal = saveImage;
//    [self setDataBox:saveImage :@"personalImage"];
	if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		// カメラから呼ばれた場合は画像をフォトライブラリに保存してViewControllerを閉じる
		UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else
	{
		// フォトライブラリから呼ばれた場合はPopOverを閉じる（iPad）
		[_popover dismissPopoverAnimated:YES];
		_popover = nil;
	}
    [self.tableView reloadData];
    [self saveImage:_personal fileName:@"self.jpg"];
    [self sendImage:_personal];
}

- (void)saveImage:(UIImage *)img fileName:(NSString *)str
{
    NSData *data = UIImageJPEGRepresentation(img,1.0);
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];

    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"OK");
    } else {
        NSLog(@"Error");
    }
}

- (UIImage *)loadImage:(NSString *)str
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];
    return [UIImage imageWithContentsOfFile:filePath];
}

- (void)sendImage:(UIImage *)img
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *ip = [appDelegate.data objectForKey:@"ip"];
    NSString *port = [appDelegate.data objectForKey:@"port"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:[port intValue] timeout:30];
        if([conn openSocket]){
#if DEBUG
            NSLog(@"openSocket success");
#endif
            NSMutableString *mes = [NSMutableString string];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
            [conn writeData:mes :img protocol:1001];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}

    /*
- (void)writeImage
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TFTCPConnection *socket = [appDelegate.data objectForKey:@"imageSocket"];
    
    NSData *data = UIImageJPEGRepresentation(_personal,1.0);
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
//    NSLog(@"%@",data);
    if([socket writeData:byteData length:len]){
        NSLog(@"writeData success");
    }else{
        NSLog(@"writeData failure");
    }
}

- (void)writeSocket:(NSString *)str
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TFTCPConnection *conn = [appDelegate.data objectForKey:@"socket"];
    if([[appDelegate.data objectForKey:@"accessFrag"] isEqualToString:@"YES"]){
        conn = [appDelegate.data objectForKey:@"socket"];
        if([conn writeStringData:str length:[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]){
            NSLog(@"writeData success");
        }else{
            NSLog(@"writeData failure");
        }
    }
}

- (IBAction)pushRightButton:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self openNetwork];
}

- (void)openNetwork
{
    int port = [[_appDelegate.data objectForKey:@"port"] intValue];
    NSString *ip = [_appDelegate.data objectForKey:@"ip"];
    
    if([[_appDelegate.data objectForKey:@"accessFrag"] isEqualToString:@"NO"]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:port timeout:30];
            if([conn openSocket]){
                [_appDelegate.data setObject:conn forKey:@"socket"];
                [_appDelegate.data setObject:@"YES" forKey:@"accessFrag"];
                
                NSMutableString *str = [[NSMutableString alloc] init];
                UIImage *img = [_appDelegate.data objectForKey:@"personalImage"];
                NSData *data = UIImageJPEGRepresentation(img,1.0);
                NSUInteger len = [data length];
                [str appendString:@"REQ_ADD_ME\n"];
                [str appendFormat:@"%@\n",[_appDelegate.data objectForKey:@"userName"]];
                [str appendString:@"self.jpg\n"];
                [str appendFormat:@"%d\n",len];
                [str appendString:@"END_OF_MESSAGE\n"];
                [self writeSocket:str];
                
                TFTCPConnection *imageConn = [[TFTCPConnection alloc] initWithHostname:ip port:52983 timeout:30];
                if([imageConn openSocket]){
                    Byte *byteData = (Byte*)malloc(len);
                    memcpy(byteData, [data bytes], len);
                    [self writeImageSocket:byteData socket:imageConn length:len];
                    [_appDelegate.data setObject:imageConn forKey:@"imageSocket"];
                }else{
                    NSLog(@"Network close.");
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self OKDialogue];
                });
                NSLog(@"Network open!");
            }else{
                [conn closeSocket];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self networkRetry];
                });
                NSLog(@"Network close.");
            }
        });
    }
}

- (void)writeImageSocket:(Byte *)data socket:(TFTCPConnection *)socket length:(int)len
{
    if([socket writeData:data length:len]){
        NSLog(@"writeData success");
    }else{
        NSLog(@"writeData failure");
    }
}
*/

// OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 ){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

// アラートフィールドに入力した文字列を取得する
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
            NSString *str;
            str = [[alertView textFieldAtIndex:0] text];
            [_appDelegate.data setObject:str forKey:@"userName"];
        }
    }else if(alertView.tag==1){
        if (buttonIndex==1) {
//            [self openNetwork];
        }
    }
    
}
@end
