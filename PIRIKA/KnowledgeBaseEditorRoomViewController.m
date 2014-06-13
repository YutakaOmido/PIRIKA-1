//
//  KnowledgeBaseEditorRoomViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/13.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "KnowledgeBaseEditorRoomViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"

@interface KnowledgeBaseEditorRoomViewController ()

@end

@implementation KnowledgeBaseEditorRoomViewController
{
    NSString *_roomFileName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    /*
     UIImage *before = [UIImage imageNamed:@"knowledge3.png"];
     UIImage *after;
     CGFloat width = self.view.bounds.size.height;
     CGFloat height = self.view.bounds.size.width;
     
     UIGraphicsBeginImageContext(CGSizeMake(width, height));
     [before drawInRect:CGRectMake(0, 0, width, height)];
     after = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     self.view.backgroundColor = [UIColor colorWithPatternImage:after];
     _tv = [[UITextView alloc] initWithFrame:CGRectMake(70, 0, 883, 362)];
     [_tv setFont:[UIFont systemFontOfSize:20]];
     _tv.backgroundColor = [UIColor clearColor];
     [self.view addSubview:_tv];
     */
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *str = [appDelegate.data objectForKey:@"roomSubject"];
    NSRange searchResult = [str rangeOfString:@"::"];
    if(searchResult.location != NSNotFound){
        NSMutableString *s = [NSMutableString stringWithString:[str substringToIndex:searchResult.location]];
        [s appendString:@".ealp"];
        _roomFileName = s;
    }else{
        _roomFileName = str;
    }
}

- (void)viewWillAppear:(BOOL)animated
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
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"truthValueRoom"]];
            [mes appendFormat:@"%@",_roomFileName];
            [conn writeData:mes protocol:1003];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",text);
            dispatch_sync(dispatch_get_main_queue(), ^{
                _tv.text = text;
            });
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = [appDelegate.data objectForKey:@"roomSubject"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushRightButton:(UIBarButtonItem *)sender {
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
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"roomSubject"]];
            [mes appendFormat:@"%@$",_roomFileName];
            [mes appendFormat:@"%@",_tv.text];
            [conn writeData:mes protocol:3002];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (![text isEqualToString:@"ACCEPT"]) {
                    NSMutableString *s = [NSMutableString string];
                    [s appendFormat:@"Syntax error is a %@ column",text];
                    
                    [self showAlert:@"Reject" message:s];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}


-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 0;
    //    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [alert show];
}
@end
