//
//  KnowledgeBaseEditorViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "KnowledgeBaseEditorViewController.h"
#import "SubjectTableViewController.h"
#import "TFTCPConnection.h"
#import "ProlMain.h"
#import "ParserException.h"

@interface KnowledgeBaseEditorViewController ()

@end

@implementation KnowledgeBaseEditorViewController
{
    NSString *_tv;
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
    _finishButton.target=self;
    _finishButton.action=@selector(pushButton:);
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tv = [appDelegate.data objectForKey:@"truthValue"];
    if ([appDelegate.data objectForKey:@"fileName"]==nil) {
        NSArray *lines = [_kbEditor.text componentsSeparatedByString:@"\n"];
        [appDelegate.data setObject:lines forKey:@"kb"];
        [self setFileName];
    }else{
        NSArray *lines = [appDelegate.data objectForKey:@"kb"];
        NSString *str = [lines componentsJoinedByString:@"\n"];
        [_kbEditor setText:str];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *lines = [_kbEditor.text componentsSeparatedByString:@"\n"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:lines forKey:@"kb"];
    [self writeData:[appDelegate.data objectForKey:@"fileName"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TextField から文字列を取得.
-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    NSArray *lines = [textView.text componentsSeparatedByString:@"\n"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:lines forKey:@"kb"];
    return YES;
}
/*
- (IBAction)pushButton:(id)sender {
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
            [mes appendFormat:@"%@",_kbEditor.text];
            [conn writeData:mes protocol:1008];
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",text);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (![text isEqualToString:@"ACCEPT"]) {
                    NSMutableString *s = [NSMutableString string];
                    [s appendFormat:@"Syntax error is a %@ column",text];
                    
                    [self showAlert:@"Reject" message:s];
                }else{
                    UITableViewStyle style = UITableViewStylePlain;
                    SubjectTableViewController *sub = [[SubjectTableViewController alloc] initWithStyle:style];
                    [self.navigationController pushViewController:sub animated:YES];
                }
            });
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}*/

- (IBAction)pushButton:(id)sender {
//    NSLog(@"%@",_kbEditor.text);
//    ComKatsuraPrologProlMain *prol = [[ComKatsuraPrologProlMain alloc] init];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    // 雰囲気出すために背景を黒く半透明する
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2)];
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];
    [indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *lmaPath = [[NSBundle mainBundle] pathForResource:@"LMA_EX" ofType:@"pl"];
    @try{
        [ComKatsuraPrologProlMain checkEALPGrammerWithNSString:_kbEditor.text withNSString:lmaPath];
        UITableViewStyle style = UITableViewStylePlain;
        SubjectTableViewController *sub = [[SubjectTableViewController alloc] initWithStyle:style];
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:sub animated:YES];
        });
    }@catch(ComIgormaznitsaProlExceptionsParserException *exception){
        NSMutableString *s = [NSMutableString string];
        [s appendFormat:@"Syntax error is a %d column",[exception getLine]];
        [self showAlert:@"Reject" message:s];
    }@catch(JavaLangException *exception){
        [exception getMessage];
    }@finally{
        dispatch_sync(dispatch_get_main_queue(), ^{
        [indicator stopAnimating];
        [loadingView removeFromSuperview];
        });
    }
    });
}

// File名を入力するアラート表示.
-(void)setFileName
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"FileName"
                                                      message:@"Plese input file name.\n Extension is \".ealp\"."
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    message.tag = 0;
    [message show];
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

// OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1
           && ([inputText rangeOfString:@".ealp"].location != NSNotFound)
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
           && ([inputText rangeOfString:@">"].location == NSNotFound))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

// アラートフィールドに入力した文字列を取得する
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (buttonIndex==0) {
            NSString *str = [[alertView textFieldAtIndex:0] text];
            [appDelegate.data setObject:str forKey:@"fileName"];
        }
    }
}

// ファイルに書き込む.(CreateFile)
- (void)writeData:(NSString *)fileName
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFileHandle *handle;
    NSArray *kb = [appDelegate.data objectForKey:@"kb"];
    NSString *str = [kb componentsJoinedByString:@"\n"];
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        a_doc_dir = [a_doc_dir stringByAppendingPathComponent:_tv];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:nil
                                              attributes:nil];
        handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
        [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }@finally {
        [handle closeFile];
    }
}
@end
