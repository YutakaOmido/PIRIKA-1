//
//  ArgumentRoomViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "ArgumentRoomViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"
#import "KnowledgeBaseEditorRoomViewController.h"
#import "KBToolbar.h"

@interface ArgumentRoomViewController ()

@end

@implementation ArgumentRoomViewController
{
    NSArray *_userList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _subject.delegate = self;
    
    /*
    UIToolbar *tb = [[KBToolbar alloc] initWithFrame:CGRectMake(0, 0, 110.0, 44.0)];
    tb.backgroundColor = [UIColor clearColor];
    tb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadImage:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    tb.items = [NSArray arrayWithObjects:refreshBtn,space,_rightButton,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:tb];
     */
    self.navigationItem.rightBarButtonItem = _rightButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _subject.text = [appDelegate.data objectForKey:@"roomSubject"];
    [self getUserListAndImage];
}

- (void)getUserListAndImage{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *ip = [appDelegate.data objectForKey:@"ip"];
    NSString *port = [appDelegate.data objectForKey:@"port"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:[port intValue] timeout:30];
        if([conn openSocket]){
            NSLog(@"openSocket success");
            NSMutableString *mes = [NSMutableString string];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
            [mes appendFormat:@"%@",[appDelegate.data objectForKey:@"roomSubject"]];
            
            [conn writeData:mes protocol:3005];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];

            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray* userlist = [text componentsSeparatedByString:@"$"];
            NSMutableArray *list = [NSMutableArray array];
            int count=0;
            
            for (int i=0; i<[userlist count]; i++) {
                NSString *name = [userlist objectAtIndex:i];
                i++;
                NSString *date = [userlist objectAtIndex:i];
                    
                UIImage *image = [self loadImage:[name stringByAppendingString:@".jpg"] :date];
                if (image==nil) {
                    [list addObject:name];
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self setPicture:count image:image];
                    });
                    count++;
                }
            }
            
            if ([list count]!=0) {
                for (int i=0; i<[list count]; i++) {
                    NSMutableString *mes = [NSMutableString string];
                    [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
                    [mes appendFormat:@"%@",list[i]];
                    [conn writeData:mes protocol:1002];
                    NSMutableData *data = [NSMutableData data];
                    [conn readData:data];
                    [self saveImage:data fileName:[[NSString alloc] initWithFormat:@"%@.jpg",list[i]]];
                    UIImage *image = [self loadImage:[[NSString alloc] initWithFormat:@"%@.jpg",list[i]]];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self setPicture:count image:image];
                    });
                }
               
                count++;
            }
            [conn closeSocket];
        }else{
            NSLog(@"openSocket Error");
        }
    });
}

- (void)setPicture:(int)num image:(UIImage *)image
{
    switch (num) {
        case 0:
            [_user0 setImage:image];
            break;
        case 1:
            [_user1 setImage:image];
            break;
        case 2:
            [_user2 setImage:image];
            break;
        case 3:
            [_user3 setImage:image];
            break;
        case 4:
            [_user4 setImage:image];
            break;
        case 5:
            [_user5 setImage:image];
            break;
        case 6:
            [_user6 setImage:image];
            break;
        case 7:
            [_user7 setImage:image];
            break;
        case 8:
            [_user8 setImage:image];
            break;
        case 9:
            [_user9 setImage:image];
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.data removeObjectForKey:@"userList"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// タッチ判定.
- (void) touchesBegan:(NSSet *) touches withEvent: (UIEvent *) event
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	UITouch * touch = [[event allTouches] anyObject];

    NSString *userName = [appDelegate.data objectForKey:@"userName"];
    if (touch.view.tag == 11) {
        KnowledgeBaseEditorRoomViewController *view = [[KnowledgeBaseEditorRoomViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }else if (touch.view.tag < [_userList count]) {
        if ([[_userList objectAtIndex:touch.view.tag] isEqualToString:userName]) {
            KnowledgeBaseEditorRoomViewController *view = [[KnowledgeBaseEditorRoomViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

- (void)saveImage:(NSData *)data fileName:(NSString *)str
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];
    
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"OK");
    } else {
        NSLog(@"Error");
    }
}

- (UIImage *)loadImage:(NSString *)fileName
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];

    return [UIImage imageWithContentsOfFile:filePath];
}

- (UIImage *)loadImage:(NSString *)fileName :(NSString *)date
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
	[inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
	NSDate *dateS = [inputDateFormatter dateFromString:date];
    NSDictionary* dic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate *d = dic.fileModificationDate;
    
    NSTimeInterval since = [dateS timeIntervalSinceDate:d];
    
    if (since>0) {
        return nil;
    }else{
        return [UIImage imageWithContentsOfFile:filePath];
    }
}
- (IBAction)touchButton:(UIButton *)sender {
//    KnowledgeBaseEditorRoomViewController *view = [[KnowledgeBaseEditorRoomViewController alloc] init];
//    [self.navigationController pushViewController:view animated:YES];
}

// アラート表示.
-(void)alertMessage:(NSString *)str
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:str
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    //    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [message show];
}

@end
