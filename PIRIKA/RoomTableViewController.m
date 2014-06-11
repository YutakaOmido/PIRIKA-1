//
//  RoomTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/11.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "RoomTableViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"
#import "KBToolbar.h"

@interface RoomTableViewController ()

@end

@implementation RoomTableViewController
{
    TFTCPConnection *_conn;
    NSMutableArray *_rooms;
}

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
    _rooms = [NSMutableArray array];
    _rightButton.target=self;
    _rightButton.action=@selector(pushRightButton:);
//    _leftButton.target=self;
//    _leftButton.action=@selector(pushLeftButton:);
    
    UIToolbar *tb = [[KBToolbar alloc] initWithFrame:CGRectMake(0, 0, 110.0, 44.0)];
    tb.backgroundColor = [UIColor clearColor];
    tb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pushLeftButton:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    tb.items = [NSArray arrayWithObjects:refreshBtn,space,_rightButton,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:tb];
    self.navigationItem.rightBarButtonItem = item;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getRoomList];
}

- (void)getRoomList{
        NSLog(@"TEST");
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
            [mes appendFormat:@"%@",[appDelegate.data objectForKey:@"truthValueRoom"]];

            [conn writeData:mes protocol:3004];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (![text isEqualToString:@""]) {
                _rooms = [[text componentsSeparatedByString:@"$"] mutableCopy];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
            });
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Room";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_rooms objectAtIndex:indexPath.row];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteRoom:[_rooms objectAtIndex:indexPath.row]];
        [_rooms removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"roomSubject"];
}

// 右上のボタンを押したときの処理.(追加処理)
- (IBAction)pushRightButton:(UIBarButtonItem *)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Subject"
                                                      message:@"Plese input subject"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    message.tag = 0;
    [message show];
}

// 左上のボタンを押したときの処理.(更新処理)
- (IBAction)pushLeftButton:(UIBarButtonItem *)sender {
    [self getRoomList];
}

// OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 )
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
        if (buttonIndex==1) {
            NSString *subject = [[alertView textFieldAtIndex:0] text];
            [appDelegate.data setObject:subject forKey:@"roomSubject"];
            
            [self createRoom];
            
        }
    }
}

-(void)createRoom{
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
            [mes appendFormat:@"%@",[appDelegate.data objectForKey:@"truthValueRoom"]];
            [conn writeData:mes protocol:3001];

            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
//            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",text);
            [self getRoomList];
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}

-(void)deleteRoom:(NSString *)room{
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
            [mes appendFormat:@"%@",room];
            [conn writeData:mes protocol:3007];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",text);
            if ([text isEqualToString:@"NOT_SUPER_USER"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self showAlert:@"Sorry!" message:@"You are not proposer of subject!"];
                });
            }
            [self getRoomList];
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
    alert.tag = 1;
    //    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [alert show];
}

@end
