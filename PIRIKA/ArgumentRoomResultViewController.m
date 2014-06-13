//
//  ArgumentRoomResultViewController.m
//  PIRIKA
//
//  Created by katsura on 2014/01/07.
//  Copyright (c) 2014年 katsura. All rights reserved.
//

#import "ArgumentRoomResultViewController.h"
#import "ArgumentResultViewController.h"
#import "WinDialogueTreeTableViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"
#import "KBToolbar.h"
#import "SemanticsTableViewController.h"
#import "SemanticsNavigationViewController.h"

@interface ArgumentRoomResultViewController ()
{
    UIPopoverController *_popOver;
    UIBarButtonItem *_rightBtn;
}

@end

@implementation ArgumentRoomResultViewController
{
    int _pageIndex;
    int _pageMax;
    UIPageViewController *_pageViewController;
    UIPageControl *_pc;
    UIPopoverController *_popSem;
    ArgumentResultViewController *_now;
    ArgumentResultViewController *_winNow;
    ArgumentResultViewController *_argGraph;
    NSMutableArray* _root;
    UIBarButtonItem *_sem;
    NSArray *_winTree;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Argument Graph";
        //        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _root = [NSMutableArray array];
    //初期ページ
    _pageIndex = 1;
    
    //最大ページ数
    _pageMax = 1;
    
    //UIPageViewControllerの宣言
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl //アニメーション
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal //水平
                           options:nil];
    
    //UIPageViewControllerのデリゲートとデータソースをselfに設定
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    //ページに表示させるビューコントローラを表示
    _argGraph = _now = [[ArgumentResultViewController alloc] initWithBackgroundImageResize:@"background2.png"];
    [_now setIndex:_pageIndex];
    
    //ページコントローラにビューコントローラを設定する
    NSArray *viewControllers = [NSArray arrayWithObject:_now];
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:NULL];
    
    //子ビューコントローラーに設定
    [self addChildViewController:_pageViewController];
    
    //ページビューコントローラを追加
    [self.view addSubview:_pageViewController.view];
    
    UIToolbar *tb = [[KBToolbar alloc] initWithFrame:CGRectMake(0, 0, 110.0, 44.0)];
    tb.backgroundColor = [UIColor clearColor];
    tb.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _sem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushLeftButton:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    tb.items = [NSArray arrayWithObjects:_sem,space,_rightButton,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:tb];
    self.navigationItem.rightBarButtonItem = item;

}

- (void)viewWillAppear:(BOOL)animated
{
    _pageViewController.view.frame = self.view.frame;
}

// 画面がアクティブになった後に呼ばれる.
- (void)viewDidAppear:(BOOL)animated
{
    [self getResult];
    _pc = [[UIPageControl alloc] init];
    _pc.frame = CGRectMake(self.view.bounds.size.width/2.0-self.view.bounds.size.width/4.0, self.view.bounds.size.height-40, self.view.bounds.size.width/2.0, 30);
    _pc.backgroundColor = [UIColor clearColor];
    [_pc addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // popOverが開いていたら閉じる
    if (_popOver.popoverVisible){
        [_popOver dismissPopoverAnimated:YES];
    }
    
    [_root removeAllObjects];
    [_now removeRectAndTextAndImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//実際に表示するビューコントローラの作成
- (ArgumentResultViewController *)setPageShowViewController{
    ArgumentResultViewController* vc = [[ArgumentResultViewController alloc] initWithBackgroundImageResize:@"background2.png"];
    [vc setIndex:_pageIndex];
    [vc createArgumentTreeWithName:[_root objectAtIndex:_pageIndex-1]];
    _winTree = [vc createWinDialogueTree];
    return vc;
}

/*
 * ページ（戻る）
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    //現在のインデックスを取得する
    _pageIndex = [self getPageIndex:(ArgumentResultViewController *)viewController];
    
    //ページインデックスが最初ならnil
    if (1 == _pageIndex) {
        return nil;
    }
    
    //ページ数を減らす
    _pageIndex--;
    _pc.currentPage = _pageIndex-1;
    
    //ビューコントローラを返す
    _argGraph = _now= [self setPageShowViewController];
    
    return _now;
}


/*
 * ページ（次へ）
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    //現在のインデックスを取得する
    _pageIndex = [self getPageIndex:(ArgumentResultViewController *)viewController];
    
    //ページインデックスが最大なら
    if (_pageMax == _pageIndex) {
        return nil;
    }
    
    //ページ数を増やす
    _pageIndex++;
    _pc.currentPage = _pageIndex-1;
    //ビューコントローラを返す
    _argGraph = _now = [self setPageShowViewController];
    
    return _now;
}

//アニメーションの終了
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    //ページが最後までめくられたら、ページを再設定
    if (completed) {
        ArgumentResultViewController* vc = [previousViewControllers objectAtIndex:0];
        [vc setIndex:_pageIndex];
    }
}

/*
 * 現在のページを取得する
 */
- (int)getPageIndex:(ArgumentResultViewController *)vc
{
    return [vc getPageIndex];
}

- (void)getResult{
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
            
            [conn writeData:mes protocol:3003];
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([data length]!=0) {
                if ([text isEqualToString:@"TRUTH_VALUE_ERROR"]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self alertMessage:@"truth value error"];
                    });
                }else{
                    NSArray *textarray = [text componentsSeparatedByString:@"$"];
                    NSMutableArray* node = nil;
                    for (int i=0; i<[textarray count]; i++) {
                        if ([[textarray objectAtIndex:i] isEqualToString:@"0"]) {
                            if (node!=nil) {
                                [_root addObject:node];
                            }
                            node = [NSMutableArray array];
                            [node addObject:[textarray objectAtIndex:i]];
                        }else{
                            [node addObject:[textarray objectAtIndex:i]];
                        }
                    }
                    if (node!=nil) {
                        [_root addObject:node];
                    }
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        _pageMax = (int)[_root count];
                        _pc.numberOfPages = _pageMax;
                        _pc.currentPage = 0;
                        [self.view addSubview:_pc];
                        [_now createArgumentTreeWithName:[_root objectAtIndex:0]];
                        _winTree = [_now createRoomWinDialogueTree];
                    });
                }
            }
        }else{
            NSLog(@"openSocket Error");
        }
        [indicator stopAnimating];
        [loadingView removeFromSuperview];
    });
    
}

// 右上のボタンを押したときの処理
- (void)pushRightButton
{
    //    [_now pushRightButton];
    if (_popOver == nil)
    {
        WinDialogueTreeTableViewController *w = [[WinDialogueTreeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        w.tableView.delegate = self;
        _popOver = [[UIPopoverController alloc] initWithContentViewController:w];
        _popOver.delegate = self;
    }
    
    // ポップオーバーが現在表示されていなければ表示する
    if (!_popOver.popoverVisible){
        [_popOver presentPopoverFromBarButtonItem:_rightBtn
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
    }else{
        [_popOver dismissPopoverAnimated:YES];
    }
    
}

- (BOOL)shouldAutorotate
{
    _pc.frame = CGRectMake(self.view.bounds.size.width/2.0-160, self.view.bounds.size.height-50, 320, 30);
    if (_winNow != nil) {
        [_winNow shouldAutorotate];
    }
    return [_now shouldAutorotate];
}

/**
 * ページコントロールタップ時にページコントロールの値を変更しない．
 */
- (void)changePageControl:(id)sender
{
    _pc.currentPage = _pageIndex-1;
}

// WinDialogueTreeTableViewController Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if (_winNow!=nil) {
            [_winNow.view removeFromSuperview];
            _winNow = nil;
        }
        return;
    }else if(_winNow==nil){
    }else{
        [_winNow.view removeFromSuperview];
    }
    _winNow = [[ArgumentResultViewController alloc] init];
    [_winNow setIndex:_pageIndex];
    _winNow.view.frame = self.view.bounds;
    if (_winTree!=nil) {
        [_winNow createArgumentTreeWithName:[_winTree objectAtIndex:indexPath.row-1]];
        [self.view addSubview:_winNow.view];
    }
}

// アラート表示.
-(void)alertMessage:(NSString *)str
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:str
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    //    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [message show];
}

- (IBAction)pushRightButton:(UIBarButtonItem *)sender {
    if (_popOver == nil)
    {
        WinDialogueTreeTableViewController *w = [[WinDialogueTreeTableViewController alloc]
                                                 initWithStyle:UITableViewStylePlain];
        [w setWinTree:_winTree];
        w.tableView.delegate = self;
        _popOver = [[UIPopoverController alloc] initWithContentViewController:w];
        _popOver.delegate = self;
    }
    
    // ポップオーバーが現在表示されていなければ表示する
    if (!_popOver.popoverVisible){
        [_popOver presentPopoverFromBarButtonItem:_rightButton
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
    }else{
        [_popOver dismissPopoverAnimated:YES];
    }
    
}

- (IBAction)pushLeftButton:(UIBarButtonItem *)sender
{
    if (_popSem == nil)
    {
        SemanticsTableViewController *w = [[SemanticsTableViewController alloc]
                                           initWithStyle:UITableViewStylePlain
                                           parentView:self.view];
        
        SemanticsNavigationViewController *s =  [[SemanticsNavigationViewController alloc] initWithRootViewController:w];
        s.navigationItem.title = @"Various Semantics";
        //        w.tableView.delegate = self;
        _popSem = [[UIPopoverController alloc] initWithContentViewController:s];
        _popSem.delegate = self;
    }
    
    // ポップオーバーが現在表示されていなければ表示する
    if (!_popSem.popoverVisible){
        [_popSem presentPopoverFromBarButtonItem:_sem
                        permittedArrowDirections:UIPopoverArrowDirectionUp
                                        animated:YES];
    }else{
        [_popSem dismissPopoverAnimated:YES];
    }
}

@end
