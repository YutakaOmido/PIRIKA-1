//
//  KnowledgeBaseTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/06.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "KnowledgeBaseTableViewController.h"
#import "TFTCPConnection.h"
#import "KBToolbar.h"

@interface KnowledgeBaseTableViewController ()

@end

@implementation KnowledgeBaseTableViewController{
    NSMutableArray *_fileName;
    NSString *_tv;
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
    
    UIToolbar *tb = [[KBToolbar alloc] initWithFrame:CGRectMake(0, 0, 110.0, 44.0)];
    tb.backgroundColor = [UIColor clearColor];
    tb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadFile:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    tb.items = [NSArray arrayWithObjects:refreshBtn,space,_addBtn,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:tb];
    self.navigationItem.rightBarButtonItem = item;
}

// 画面がアクティブになる前に呼ばれる.
- (void)viewDidAppear:(BOOL)animated{
    self.clearsSelectionOnViewWillAppear = YES;
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_appDelegate.data removeObjectForKey:@"kb"];
    [_appDelegate.data removeObjectForKey:@"fileName"];
    [self refreshFileList];
    [self.tableView reloadData];
}

- (void)refreshFileList
{
    _fileName = [NSMutableArray array];
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    _tv = [_appDelegate.data objectForKey:@"truthValue"];
    a_doc_dir = [a_doc_dir stringByAppendingPathComponent:_tv];
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *l = [fileManager contentsOfDirectoryAtPath:a_doc_dir
                                                     error:&error];
    NSMutableArray *list = [l mutableCopy];
    [list removeObject:@".DS_Store"];
    for (int i=0; i<[list count]; i++) {
        NSString *s = [list objectAtIndex:i];
        if (([s rangeOfString:@".pl"].location != NSNotFound)) {
            [list removeObject:s];
        }
    }
    // ファイルやディレクトリの一覧を表示する
    for (NSString *path in list) {
        [_fileName addObject:path];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// セクション数を規定.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セクション内のアイテム数を返す.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileName count];
}

// セルにデータをセット.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Knowledge";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_fileName objectAtIndex:indexPath.row];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteFile:[_fileName objectAtIndex:indexPath.row]];
        [_fileName removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// 押されたセルを判別.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:[_fileName objectAtIndex:indexPath.row] forKey:@"fileName"];
    [self readFile:[_fileName objectAtIndex:indexPath.row]];
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

// 指定されたファイル名のデータを取り出す.
- (void)readFile:(NSString *)fileName
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFileHandle *handle;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        a_doc_dir = [a_doc_dir stringByAppendingPathComponent:_tv];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
        handle=[NSFileHandle fileHandleForReadingAtPath:filePath];
        NSArray *lines;
        
        if (handle) {
            NSData *data=[handle readDataToEndOfFile];
            NSString* text=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            lines = [text componentsSeparatedByString:@"\n"];
            [appDelegate.data setObject:lines forKey:@"kb"];
        }
        
    }@finally {
        [handle closeFile];
    }
}

- (IBAction)downloadFile:(UIBarButtonItem *)sender {
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
            [mes appendFormat:@"%@",[appDelegate.data objectForKey:@"truthValue"]];
            
            [conn writeData:mes protocol:1004];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            
            NSArray *fileList;
            if ([data length]!=0) {
                NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                fileList = [text componentsSeparatedByString:@"$"];
                for (int i=0; i<[fileList count]; i++) {
                    NSMutableString *mes = [NSMutableString string];
                    [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
                    [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"truthValue"]];
                    [mes appendFormat:@"%@", fileList[i]];
                    [conn writeData:mes protocol:1003];
                    
                    NSMutableData *contents = [NSMutableData data];
                    [conn readData:contents];
                    if ([contents length]!=0) {
                        [self createFile:fileList[i] :[[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding]];
                    }
                }
            }
            
            [conn closeSocket];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self refreshFileList];
                [self.tableView reloadData];
            });
        }else{
#if DEBUG
            NSLog(@"openSocket Error");
#endif
        }
    });
}


// File作成.
- (void)createFile:(NSString *)fileName :(NSString *)str
{
    NSFileHandle *handle;
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

// File削除.
- (BOOL)deleteFile:(NSString *)fileName
{
    NSString *a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    a_doc_dir = [a_doc_dir stringByAppendingPathComponent:_tv];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 削除したいファイルのパスを作成
    NSString *filePath = [a_doc_dir stringByAppendingPathComponent:fileName];
    NSError *error;
    // ファイルを移動
    BOOL result = [fileManager removeItemAtPath:filePath error:&error];
    return result;
}
@end
