//
//  ArgumentResultRootViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/25.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "ArgumentResultRootViewController.h"
#import "ArgumentResultViewController.h"
#import "WinDialogueTreeTableViewController.h"
#import "AppDelegate.h"
#import "TFTCPConnection.h"
#import "ProlMain.h"
#import "JavaArgumentTree.h"
#include "java/util/Map.h"
#include "java/util/HashMap.h"
#include "java/util/List.h"
#include "java/util/ArrayList.h"

@interface ArgumentResultRootViewController ()
{
    UIPopoverController *_popOver;
    UIBarButtonItem *_rightBtn;
}

@end

@implementation ArgumentResultRootViewController
{
    int _pageIndex;
    int _pageMax;
    UIPageViewController *_pageViewController;
    UIPageControl *_pc;
    ArgumentResultViewController *_now;
    ArgumentResultViewController *_winNow;
    ArgumentResultViewController *_argGraph;
    NSMutableArray* _root;
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
    
    // 右側のボタン作成
    _rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply  // スタイルを指定
                                                                         target:self  // デリゲートのターゲットを指定
                                                                         action:@selector(pushRightButton)
                            ];
    self.navigationItem.rightBarButtonItem = _rightBtn;
//    UIImage *backgroundImage = [UIImage imageNamed:@"background2.png"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pageViewController.view.frame = self.view.frame;
}

// 画面がアクティブになった後に呼ばれる.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getResult];
    _pc = [[UIPageControl alloc] init];
    _pc.frame = CGRectMake(self.view.bounds.size.width/2.0-self.view.bounds.size.width/4.0, self.view.bounds.size.height-40, self.view.bounds.size.width/2.0, 30);
    _pc.backgroundColor = [UIColor clearColor];
    [_pc addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // popOverが開いていたら閉じる
    if (_popOver.popoverVisible){
        [_popOver dismissPopoverAnimated:YES];
    }
    [_root removeAllObjects];
    [_now removeRectAndTextAndImage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
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
/*
- (void)getResult{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *ip = [appDelegate.data objectForKey:@"ip"];
    NSString *port = [appDelegate.data objectForKey:@"port"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    TFTCPConnection *conn = [[TFTCPConnection alloc] initWithHostname:ip port:[port intValue] timeout:30];
        if([conn openSocket]){
            NSLog(@"openSocket success");
            NSMutableString *mes = [NSMutableString string];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"userName"]];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"fileName"]];
            [mes appendFormat:@"%@$",[appDelegate.data objectForKey:@"subject"]];
            NSArray *lines = [appDelegate.data objectForKey:@"kb"];
            NSString *str = [lines componentsJoinedByString:@"\n"];
            [mes appendFormat:@"%@$",str];
            NSString *tv = [appDelegate.data objectForKey:@"truthValue"];
            NSArray *ar = [NSArray arrayWithObjects:@"01Value", @"2Value", @"4Value", @"7Value", @"IntValue",nil];

            if([tv isEqualToString:ar[0]]){
                [conn writeData:mes protocol:2001];
            }else if([tv isEqualToString:ar[1]]){
                [conn writeData:mes protocol:2002];
            }else if([tv isEqualToString:ar[2]]){
                [conn writeData:mes protocol:2003];
            }else if([tv isEqualToString:ar[3]]){
                [conn writeData:mes protocol:2004];
            }else if([tv isEqualToString:ar[4]]){
                [conn writeData:mes protocol:2005];
            }else{
                [mes appendFormat:@"%@",tv];
                [conn writeData:mes protocol:2006];
            }
            
            NSMutableData *data = [NSMutableData data];
            [conn readData:data];
            [conn closeSocket];
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *textarray = [text componentsSeparatedByString:@"$"];

            if (data.length!=0) {
                if ([text isEqualToString:@"TRUTH_VALUE_ERROR"]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self alertMessage:@"truth value error"];
                    });
                }else{
                    [appDelegate.data setObject:data forKey:@"argumentTree"];
                    
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
    });

}
*/

- (void)getResult{
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(loadingView.bounds.size.width / 2, loadingView.bounds.size.height / 2)];
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];
    [indicator startAnimating];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *tv = [appDelegate.data objectForKey:@"truthValue"];
        NSString *fileName = [appDelegate.data objectForKey:@"fileName"];
        NSArray *ar = [NSArray arrayWithObjects:@"01Value", @"2Value", @"4Value", @"7Value", @"IntValue",nil];
        NSString *lmaPath = [[NSBundle mainBundle] pathForResource:@"LMA_EX" ofType:@"pl"];
        
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        a_doc_dir = [a_doc_dir stringByAppendingPathComponent:tv];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:fileName];
        
        ComKatsuraPrologJavaArgumentTree *tree = [[ComKatsuraPrologJavaArgumentTree alloc] init];
        NSString *truthvaluePath;
        
        if([tv isEqualToString:ar[0]]){
            truthvaluePath = [[NSBundle mainBundle] pathForResource:@"01value" ofType:@"pl"];
        }else if([tv isEqualToString:ar[1]]){
            truthvaluePath = [[NSBundle mainBundle] pathForResource:@"2value" ofType:@"pl"];
        }else if([tv isEqualToString:ar[2]]){
            truthvaluePath = [[NSBundle mainBundle] pathForResource:@"4value" ofType:@"pl"];
        }else if([tv isEqualToString:ar[3]]){
            truthvaluePath = [[NSBundle mainBundle] pathForResource:@"7value" ofType:@"pl"];
        }else if([tv isEqualToString:ar[4]]){
            truthvaluePath = [[NSBundle mainBundle] pathForResource:@"intvalue" ofType:@"pl"];
        }else{
            truthvaluePath = [[NSBundle mainBundle] pathForResource:tv ofType:@"pl"];
        }
        id<JavaUtilMap> map = [[JavaUtilHashMap alloc] init];
        (void) [map putWithId:@"test" withId:filePath];
        
        [tree init__WithNSString:lmaPath withNSString:truthvaluePath withJavaUtilMap:map];
        
        NSString *subject = [appDelegate.data objectForKey:@"subject"];
        id<JavaUtilList> list = [tree calculateWithNSString:subject];
        IOSObjectArray *array = [list toArray];
//        for (int i=0; i<[array count]; i++) {
//            NSLog(@"%@",[array objectAtIndex:i]);
//        }
        
        NSMutableArray* node = nil;
        for (int i=0; i<[array count]; i++) {
            if ([[array objectAtIndex:i] isEqualToString:@"0"]) {
                if (node!=nil) {
                    [_root addObject:node];
                }
                node = [NSMutableArray array];
                [node addObject:[array objectAtIndex:i]];
            }else{
                [node addObject:[array objectAtIndex:i]];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [loadingView removeFromSuperview];
            
            if (node!=nil) {
                [_root addObject:node];
            }
            _pageMax = (int)[_root count];
            _pc.numberOfPages = _pageMax;
            _pc.currentPage = 0;
            [self.view addSubview:_pc];
            [_now createArgumentTreeWithName:[_root objectAtIndex:0]];
            _winTree = [_now createRoomWinDialogueTree];
        });
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
        [w setWinTree:_winTree];
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
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.data setObject:[_argGraph getRootNode] forKey:@"rootNode"];
    }else if(_winNow==nil){
        _winNow = [[ArgumentResultViewController alloc] init];
        [_winNow setIndex:_pageIndex];
        _winNow.view.frame = self.view.bounds;
        
        if (_winTree!=Nil) {
            [_winNow createArgumentTreeWithName:[_winTree objectAtIndex:indexPath.row-1]];
            [self.view addSubview:_winNow.view];
        }
    }else{
        [_winNow.view removeFromSuperview];
        _winNow = [[ArgumentResultViewController alloc] init];
        [_winNow setIndex:_pageIndex];
        _winNow.view.frame = self.view.bounds;
        if (_winTree!=Nil) {
            [_winNow createArgumentTreeWithName:[_winTree objectAtIndex:indexPath.row-1]];
            [self.view addSubview:_winNow.view];
        }
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
@end
