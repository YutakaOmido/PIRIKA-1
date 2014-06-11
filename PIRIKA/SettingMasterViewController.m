//
//  SettingMasterViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/07/03.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "SettingMasterViewController.h"
#import "SettingDetailViewController.h"

@interface SettingMasterViewController ()
{
    SettingDetailViewController *_detailView;
    NSArray *_masterKey;
    NSArray *_masterPersonal;
    NSArray *_masterNerwork;
//    NSMutableArray *_masterTruthValue;
}

@end

@implementation SettingMasterViewController

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
    _masterKey = [NSArray arrayWithObjects: @"Identity",
                                            @"Network",
                                            @"",
                                            nil];
    _masterPersonal = [NSArray arrayWithObjects:@"Name & Image",
                                                nil];
    _masterNerwork = [NSArray arrayWithObjects: @"Connect",
                      nil];
//    _masterTruthValue = [NSArray arrayWithObjects: @"TruthValue",
//                      nil];
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
    return [_masterKey count];
}

// セクション内のアイテム数を返す.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [_masterPersonal count];
            break;
        case 1:
            return [_masterNerwork count];
            break;
        case 2:
//            return [_masterTruthValue count];
            break;
        default:
            break;
    }
    return 0;
}

// セルの中身を返す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Master";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [_masterPersonal objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [_masterNerwork objectAtIndex:indexPath.row];
            break;
        case 2:
//            cell.textLabel.text = [_masterTruthValue objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

// セクション名を返す.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)[_masterKey objectAtIndex:section];
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
    [_detailView setMasterIndexPath:indexPath];
    [_detailView.tableView reloadData];
}

- (void)setDetailViewContoller:(id)view
{
    _detailView = view;
}
@end
