//
//  UserDefineViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/28.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "UserDefineViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"

@interface UserDefineViewController ()
{
    NSString *_fileName;
    AppDelegate *_appDelegate;
}

@end

@implementation UserDefineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)pushRightButton:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *ip = [appDelegate.data objectForKey:@"ip"];
    NSString *port = [appDelegate.data objectForKey:@"port"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:[port intValue] timeout:30];
        if([conn openSocket]){
            NSLog(@"openSocket success");
            NSMutableString *mes = [NSMutableString string];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
            [mes appendFormat:@"%@$",_fileName];
            [mes appendFormat:@"%@",_text.text];
            [conn writeData:mes protocol:1005];
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            if ([data length]!=0) {
                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if ([text isEqualToString:@"ACCEPT"]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showAlert:@"Accept" message:@"Thanks you."];
                    });
                }else{
                    NSMutableString *s = [NSMutableString string];
                    [s appendFormat:@"Syntax error is a %@ column",text];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showAlert:@"Reject" message:s];
                    });
                }
            }
        }
    });
}

- (id)initWithText:(NSString *)str
{
    self = [super init];
    if (self) {
        _text.text = str;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([_appDelegate.data objectForKey:@"truthValueFileName"]!=nil) {
        _fileName = [_appDelegate.data objectForKey:@"truthValueFileName"];
        _text.text = [self readFile:[_fileName stringByReplacingOccurrencesOfString:@".pl" withString:@""]];
    }else{
        [self fileNameDialogue];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self writeFile:_text.text];
    [_appDelegate.data removeObjectForKey:@"truthValueFileName"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ファイル名.
-(void)fileNameDialogue
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"FileName"
                                                      message:@"Please input file name.\n Extension is \".pl\"."
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    message.tag = 0;
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [message show];
}

// OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1
           && ([inputText rangeOfString:@".pl"].location != NSNotFound)
           && ([inputText rangeOfString:@"$"].location == NSNotFound)
           && ([inputText rangeOfString:@":"].location == NSNotFound)
           && ([inputText rangeOfString:@";"].location == NSNotFound)
           && ([inputText rangeOfString:@"/"].location == NSNotFound)
           && ([inputText rangeOfString:@"\\"].location == NSNotFound)
           && ([inputText rangeOfString:@"|"].location == NSNotFound)
           && ([inputText rangeOfString:@","].location == NSNotFound)
           && ([inputText rangeOfString:@"*"].location == NSNotFound)
           && ([inputText rangeOfString:@"?"].location == NSNotFound)
           && ([inputText rangeOfString:@"\""].location == NSNotFound)
           && ([inputText rangeOfString:@"<"].location == NSNotFound)
           && ([inputText rangeOfString:@">"].location == NSNotFound)){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

// アラートフィールドに入力した文字列を取得する
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==0) {
            _fileName = [[alertView textFieldAtIndex:0] text];
        }
    }else if(alertView.tag==1){
        if ([alertView.title isEqualToString:@"Accept"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
}

- (void)writeFile:(NSString *)str
{
    NSFileHandle *handle;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
        NSString *f = [_fileName stringByReplacingOccurrencesOfString:@".pl" withString:@""];
        a_doc_dir = [a_doc_dir stringByAppendingPathComponent:f];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:a_doc_dir]) {
            NSString *filePath=[a_doc_dir stringByAppendingPathComponent:_fileName];
            [[NSFileManager defaultManager] createFileAtPath:filePath
                                                    contents:nil
                                                  attributes:nil];
            handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
            [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [[NSFileManager defaultManager] createDirectoryAtPath:a_doc_dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
            NSString *filePath=[a_doc_dir stringByAppendingPathComponent:_fileName];
            [[NSFileManager defaultManager] createFileAtPath:filePath
                                                    contents:nil
                                                  attributes:nil];
            handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
            [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }@finally {
        [handle closeFile];
    }
}

- (NSString *)readFile:(NSString *)fileDir
{
    NSFileHandle *handle;
    NSString *text;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileDir];
        NSString *fileName = [fileDir stringByAppendingString:@".pl"];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        handle=[NSFileHandle fileHandleForReadingAtPath:filePath];
        
        if (handle) {
            NSData *data=[handle readDataToEndOfFile];
            text=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }@finally {
        [handle closeFile];
    }
    return text;
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 1;
//    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [alert show];
}
@end
