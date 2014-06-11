//
//  KnowledgeBaseTruthValueViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/29.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "KnowledgeBaseTruthValueViewController.h"
#import "AppDelegate.h"

@interface KnowledgeBaseTruthValueViewController ()

@end

@implementation KnowledgeBaseTruthValueViewController
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
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    _fileList = [array mutableCopy];
    [_fileList removeObject:@".DS_Store"];
    [self.tableView reloadData];
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
                cell = [tableView dequeueReusableCellWithIdentifier:@"intValue" forIndexPath:indexPath];
                return cell;
                break;
            default:
                break;
        }
    }else{
        NSString *str = [_fileList objectAtIndex:indexPath.row];
        str = [str stringByReplacingOccurrencesOfString:@".pl" withString:@""];
        cell = [tableView dequeueReusableCellWithIdentifier:@"userDefine" forIndexPath:indexPath];
        cell.textLabel.text = str;
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
    if (indexPath.section==0) {
        NSArray *ar = [NSArray arrayWithObjects:@"01Value", @"2Value", @"4Value", @"7Value", @"IntValue",nil];
        [_appDelegate.data setObject:[ar objectAtIndex:indexPath.row] forKey:@"truthValue"];
    }else{
        NSString *str = [_fileList objectAtIndex:indexPath.row];
        NSMutableString *string = [NSMutableString stringWithString:@"UserDefine/"];
        [string appendFormat:@"%@",str];
        [_appDelegate.data setObject:string forKey:@"truthValue"];
    }
}

- (NSString *)readFile:(NSString *)fileName
{
    NSFileHandle *handle;
    NSString *text;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents/UserDefine"];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
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

@end
