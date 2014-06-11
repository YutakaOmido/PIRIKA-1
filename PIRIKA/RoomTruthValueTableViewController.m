//
//  RoomTruthValueTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/30.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "RoomTruthValueTableViewController.h"
#import "AppDelegate.h"

@interface RoomTruthValueTableViewController ()

@end

@implementation RoomTruthValueTableViewController
{
    NSArray *_default;
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
    _default = [[NSArray alloc] initWithObjects:@"01Value", @"2Value", @"4Value", @"7Value", @"IntValue", nil];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [_default count];
    }else if (section==1){
        return [_fileList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"truthValue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.textLabel.text = [_default objectAtIndex:indexPath.row];
    }else if(indexPath.section==1){
        cell.textLabel.text = [_fileList objectAtIndex:indexPath.row];
    }
    
    // Configure the cell...
    
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
        [_appDelegate.data setObject:[_default objectAtIndex:indexPath.row] forKey:@"truthValueRoom"];
    }else{
        NSString *str = [_fileList objectAtIndex:indexPath.row];
        NSMutableString *string = [NSMutableString stringWithString:@"UserDefine/"];
        [string appendFormat:@"%@",str];
        [_appDelegate.data setObject:string forKey:@"truthValueRoom"];
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

@end
