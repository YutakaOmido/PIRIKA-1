//
//  SemanticsTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/11/16.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "SemanticsTableViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"
#import "Node.h"
#import "ArgumentFrameView.h"
#import "GroundedTableViewController.h"
#import "CompleteTableViewController.h"
#import "StableTableViewController.h"
#import "PreferredTableViewController.h"

@interface SemanticsTableViewController ()

@end

@implementation SemanticsTableViewController
{
    UIView *_parent;
    ArgumentFrameView *af;
    dispatch_semaphore_t _semaphore;
}

- (id)initWithStyle:(UITableViewStyle)style parentView:(UIView *)p
{
    self = [super initWithStyle:style];
    if (self) {
        _parent = p;
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Semantics";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *str;
    
    switch (indexPath.row) {
        case 0:
            str = @"Argument Graph on the issue";
            break;
        case 1:
            str = @"Argument Framework";
            break;
        case 2:
            str = @"Grounded Semantics";
            break;
        case 3:
            str = @"Complete Semantics";
            break;
        case 4:
            str = @"Stable Semantics";
            break;
        case 5:
            str = @"Preferred Semantics";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [af removeFromSuperview];
        af = nil;
        return;
    }
    if (af==nil) {
        [self initFrame];
    }else{
        dispatch_semaphore_signal(_semaphore);
    }
    
    while(dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    
    GroundedTableViewController *g = [[GroundedTableViewController alloc] initWithStyle:UITableViewStylePlain frame:af];
    CompleteTableViewController *c = [[CompleteTableViewController alloc] initWithStyle:UITableViewStylePlain frame:af];
    PreferredTableViewController *p = [[PreferredTableViewController alloc] initWithStyle:UITableViewStylePlain frame:af];
    StableTableViewController *s = [[StableTableViewController alloc] initWithStyle:UITableViewStylePlain frame:af];
    
    
    switch (indexPath.row) {
        case 0:
            [af removeFromSuperview];
            af = nil;
            break;
        case 1:
            [af resetColor];
            break;
        case 2:
            [self.navigationController pushViewController:g animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:c animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:s animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:p animated:YES];
            break;
        default:
            break;
    }
}

- (void)initFrame
{
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
            [conn writeData:mes protocol:3006];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            if ([data length]!=0) {
                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSArray *n = [text componentsSeparatedByString:@"$"];
                NSMutableArray *node = [NSMutableArray array];
                CGFloat x = _parent.bounds.size.width;
                CGFloat y = _parent.bounds.size.height;
                
                for (int i=0; i<[n count]; i++) {
                    Node *k = [[Node alloc] initWithFrame:CGRectMake(x/2.0,y/2.0, 50, 50)];
                    [node addObject:k];
                }
                
                // 送られてきた情報を分解してnodeに保管
//                NSLog(@"%ld",[node count]);
                for (int i=0; i<[node count]; i++) {
                    NSString *s = [n objectAtIndex:i];
                    NSArray *a = [s componentsSeparatedByString:@"/"];
                    
                    Node *n = [node objectAtIndex:i];
                    n.num = i;
                    
                    NSString *s1 = a[1];
                    
                    if (![s1 isEqualToString:@"[]"]) {
                        s1 = [s1 substringWithRange:NSMakeRange(1, [s1 length]-2)];
                        NSArray *s1array = [s1 componentsSeparatedByString:@","];
                        
                        for (int j=0; j<[s1array count]; j++) {
                            NSString *num = [s1array objectAtIndex:j];
                            [n addRecieveRelation:num ref:[node objectAtIndex:[num intValue]]];
                        }
                    }
                    
                    NSString *s2 = a[2];
                    if (![s2 isEqualToString:@"[]"]) {
                        s2 = [s2 substringWithRange:NSMakeRange(1, [s2 length]-2)];
                        NSArray *s2array = [s2 componentsSeparatedByString:@","];
                        
                        for (int j=0; j<[s2array count]; j++) {
                            NSString *num = [s2array objectAtIndex:j];
                            [n addAttackRelation:num ref:[node objectAtIndex:[num intValue]]];
                        }
                    }
                    
                    NSString *s3 = a[3];
                    [s3 substringWithRange:NSMakeRange(1, [s3 length]-2)];
                    n.argument = s3;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    af = [[ArgumentFrameView alloc] initWithFrame:_parent.frame Node:[node copy]];
                    af.backgroundColor = [UIColor whiteColor];
                    [_parent addSubview:af];
                });
            }
        }
        dispatch_semaphore_signal(_semaphore);
    });
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
