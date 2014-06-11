//
//  SubjectTableViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "SubjectTableViewController.h"
#import "ArgumentResultViewController.h"
#import "ArgumentResultRootViewController.h"

@interface SubjectTableViewController ()

@end

@implementation SubjectTableViewController{
    NSMutableArray *subject;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Subjects";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self action:@selector(pushRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 画面がアクティブになる前に呼ばれる.
- (void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    subject = [NSMutableArray array];
    NSArray *lines = [appDelegate.data objectForKey:@"kb"];
    
    // 知識ベースから議題を抽出.
    /*
    for (int i=0; i<[lines count]; i++) {
        NSRange searchResult = [lines[i] rangeOfString:@"<=="];
        if(!(searchResult.location == NSNotFound)){
            BOOL frag=true;
            for (int j=0; j<[subject count]; j++) {
                NSRange searchResult = [lines[i] rangeOfString:subject[j]];
//                if(!(searchResult.location == NSNotFound)){
                if([lines[i] isEqualToString:subject[j]]){
                    frag = false;
                    break;
                }
            }
            if(frag){
                NSString *str = [lines[i] substringToIndex:searchResult.location];
                str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [subject addObject:str];
            }
        }
    }*/
    
    for (int i=0; i<[lines count]; i++) {
        NSString *s = [lines objectAtIndex:i];
        NSArray *l = [s componentsSeparatedByString:@"<=="];
        s = [l[0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![subject containsObject:s] && ![s isEqualToString:@""] && ([s rangeOfString:@"%"].location == NSNotFound)) {
            [subject addObject:s];
        }
    }
    
    [_subjectTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushRightButton
{
    [self inputSubject];
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
    return [subject count];
}

// セルにデータをセット.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Subject";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [subject objectAtIndex:indexPath.row];
    return cell;
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

// 押されたセルを判別.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.data setObject:[subject objectAtIndex:indexPath.row] forKey:@"subject"];
    ArgumentResultRootViewController *arg = [[ArgumentResultRootViewController alloc] init];
    [self.navigationController pushViewController:arg animated:YES];
}


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

-(void)inputSubject
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Subject"
                                                      message:@"Plese input subject"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [message show];
}

// OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 ){
        return YES;
    }else{
        return NO;
    }
}

// アラートフィールドに入力した文字列を取得する
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.data setObject:[[alertView textFieldAtIndex:0] text] forKey:@"subject"];
        ArgumentResultRootViewController *arg = [[ArgumentResultRootViewController alloc] init];
        [self.navigationController pushViewController:arg animated:YES];
    }
}

@end
