//
//  TruthValueTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/28.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "TruthValueTableViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"

@interface TruthValueTableViewController ()

@end

@implementation TruthValueTableViewController
{
    NSMutableArray *_fileList;
    AppDelegate *_appDelegate;
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
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
    

    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:a_doc_dir error:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *ip = [appDelegate.data objectForKey:@"ip"];
    NSString *port = [appDelegate.data objectForKey:@"port"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:[port intValue] timeout:30];
        if([conn openSocket]){
            NSLog(@"openSocket success");
            NSMutableString *mes = [NSMutableString string];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
            [conn writeData:mes protocol:1007];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            
            if ([data length]!=0) {
                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (![text isEqualToString:@""]) {
                    NSArray *a = [text componentsSeparatedByString:@"$"];
                    
                    for (int i=0; i<[a count]; i++) {
                        if (![array containsObject:a[i]]) {
                            NSMutableString *mes = [NSMutableString string];
                            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
                            [mes appendFormat:@"%@",a[i]];
                            [conn writeData:mes protocol:1006];
                            NSMutableData *data = [NSMutableData data];
                            [conn readData:data];
                            if ([data length]!=0) {
                                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                [self writeFile:a[i] contents:text];
                            }
                        }
                    }
                }
                
            }
            [conn closeSocket];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:a_doc_dir error:nil];
            _fileList = [array mutableCopy];
            [_fileList removeObject:@".DS_Store"];
            [self.tableView reloadData];
        });
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 5;
    }else{
        return _fileList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"01Value" forIndexPath:indexPath];
                return cell;
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"2Value" forIndexPath:indexPath];
                return cell;
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"4Value" forIndexPath:indexPath];
                return cell;
                break;
            case 3:
                cell = [tableView dequeueReusableCellWithIdentifier:@"7Value" forIndexPath:indexPath];
                return cell;
                break;
            case 4:
                cell = [tableView dequeueReusableCellWithIdentifier:@"IntValue" forIndexPath:indexPath];
                return cell;
                break;
            default:
                break;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"userDefine" forIndexPath:indexPath];
        cell.textLabel.text = [_fileList objectAtIndex:indexPath.row];
        return cell;
    }
    static NSString *CellIdentifier = @"01Value";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"Default";
            break;
        case 1:
            return @"User define";
            break;
    }
    return nil; //ビルド警告回避用
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
    if (indexPath.section==1) {
        NSString *f = [_fileList objectAtIndex:indexPath.row];
        f = [f stringByAppendingString:@".pl"];
        [_appDelegate.data setObject:f forKey:@"truthValueFileName"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteFile:[_fileList objectAtIndex:indexPath.row]];
        [_fileList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// セルに色づけ
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For even
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    // For odd
    else {
        cell.backgroundColor = [UIColor colorWithHue:0.61
                                          saturation:0.09
                                          brightness:0.99
                                               alpha:1.0];
    }
}

// File削除.
- (BOOL)deleteFile:(NSString *)fileDir
{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
    NSString *filePath = [a_doc_dir stringByAppendingPathComponent:fileDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // ファイルを移動
    BOOL result = [fileManager removeItemAtPath:filePath error:&error];
    return result;
}

- (void)writeFile:(NSString *)fileName contents:(NSString *)contents
{
    NSFileHandle *handle;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
        NSString *f = [fileName stringByReplacingOccurrencesOfString:@".pl" withString:@""];
        a_doc_dir = [a_doc_dir stringByAppendingPathComponent:f];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:a_doc_dir]) {
            NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] createFileAtPath:filePath
                                                    contents:nil
                                                  attributes:nil];
            handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
            [handle writeData:[contents dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [[NSFileManager defaultManager] createDirectoryAtPath:a_doc_dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
            NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] createFileAtPath:filePath
                                                    contents:nil
                                                  attributes:nil];
            handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
            [handle writeData:[contents dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }@finally {
        [handle closeFile];
    }
}
@end
