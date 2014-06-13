//
//  ArgumentResultViewController.m
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "ArgumentResultViewController.h"
#import "ArgumentTree.h"
#import "DrawRect.h"

#define ORIENTATION [[UIDevice currentDevice] orientation]

@interface ArgumentResultViewController ()

@end

@implementation ArgumentResultViewController
{
    UIScrollView *_scrollView;
    UIView *_subResultView;
    UITapGestureRecognizer*_singleTapGesture;
    BOOL _scrollViewMoveFrag;
    int _index;
    UIPageViewController *_pageViewController;
    ArgumentTree *_rootNode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 勝利対話木用テーブル
    /*
    _winDialogueTree= [[UITableView alloc]
                       initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 200, self.view.bounds.size.height)
                       style:UITableViewStylePlain];
    _winDialogueTree.delegate = self;
    _winDialogueTree.dataSource = self;
    [self.view addSubview:_winDialogueTree];*/
    _scrollViewMoveFrag = false;
    /* 2本でタップ */
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDableTapped:)];
    tapGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    /* 1本でタップ */
    _singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewSingleTapped:)];
    _singleTapGesture.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:_singleTapGesture];
//    self.view.backgroundColor = [UIColor clearColor];
}

// 画面がアクティブになる前に呼ばれる.
- (void)viewWillAppear:(BOOL)animated
{
}

// 画面がアクティブになった後に呼ばれる.
- (void)viewDidAppear:(BOOL)animated
{
//    [self openNetwork];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init {
    self = [super init];
    if (self) {
        UIImage *before = [UIImage imageNamed:@"background.png"];
        UIImage *after;
        CGFloat width = self.view.bounds.size.height;
        CGFloat height = self.view.bounds.size.width-98;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [before drawInRect:CGRectMake(0, 0, width, height)];
        after = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = [UIColor colorWithPatternImage:after];
        [self rotateInit];
    }
    return self;
}

- (id)initWithBackgroundImage:(NSString *)str
{
    self = [super init];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:str];
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        [self rotateInit];
    }
    return self;
}

- (id)initWithBackgroundClearColor
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        [self rotateInit];
    }
    return self;
}

- (id)initWithBackgroundImageResize:(NSString *)str
{
    self = [super init];
    if (self) {
        UIImage *before = [UIImage imageNamed:str];
        UIImage *after;
        CGFloat width = self.view.bounds.size.height;
        CGFloat height = self.view.bounds.size.width-98;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [before drawInRect:CGRectMake(0, 0, width, height)];
        after = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = [UIColor colorWithPatternImage:after];
        [self rotateInit];
    }
    return self;
}

- (ArgumentTree *)getRootNode
{
    return _rootNode;
}

- (void)rotateInit
{
    // UIScrollViewのインスタンス化
    _scrollView = [[UIScrollView alloc]init];
    // UIScrollViewのサイズを指定
    int direction = self.interfaceOrientation;
    CGRect r = [[UIScreen mainScreen] bounds];
    if(direction == UIInterfaceOrientationPortrait){
        //            _scrollView.frame = self.view.bounds;
        _scrollView.frame = r;
    }else if(direction == UIInterfaceOrientationLandscapeLeft
             || direction == UIInterfaceOrientationLandscapeRight){
        _scrollView.frame = CGRectMake(0, 0, r.size.height, r.size.width);
    }
    
    _scrollView.delegate = self;
    // スクロールしたときバウンドさせる
    _scrollView.bounces = YES;
    _scrollView.maximumZoomScale = 5.0;
    // UIScrollViewのコンテンツサイズを画像のサイズに合わせる
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+300);
    
    _subResultView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                              0.0,
                                                              _scrollView.frame.size.width,
                                                              _scrollView.frame.size.height)];
    [_scrollView addSubview:_subResultView];
    // UIScrollViewのインスタンスをビューに追加
    [self.view addSubview:_scrollView];
    // 表示されたときスクロールバーを点滅
    [_scrollView flashScrollIndicators];
    
//    _winDialogueTree.frame = CGRectMake(self.view.bounds.size.width, 0, 200, self.view.bounds.size.height);
}
    
- (void)createArgumentTree:(NSMutableArray *)result
{
    // 各ノードの最大幅を規定.
    CGFloat size = 100;
    // ノード同士の幅を規定.
    int space = 30;
    srand((unsigned int)time(nil));
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect r = _scrollView.bounds;

    CGFloat w = r.size.width;
    
    // 各接点の最大幅を調べる.
    int width[([result count]+1)/2];
    for (int j=0; j<[result count]; j=j+2) {
        int root = [[result objectAtIndex:j] intValue];
        int max = 0;
        int prev = -1;
        for (int i=j+2; i<([result count]) && root <[[result objectAtIndex:i] intValue]; i=i+2) {
            if(prev == [[result objectAtIndex:i] intValue]){
                max++;
            }else if(prev > [[result objectAtIndex:i] intValue]){
                max++;
            }
            prev = [[result objectAtIndex:i] intValue];
        }
        max++;
        width[j/2]=max;
    }
    
    // ノードの個数によってノード同士の間隔とノード数を調整
    if ((CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])<space) {
        space = space/3;
    }
    if (size > (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])) {
        size = (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0]);
    }
    
    // 配列を木構造へ変更.
    NSMutableArray *tree = [NSMutableArray array];
    int maxdepth=0; // 最大深度
    for (int i=0; i<[result count]; i=i+2) {
        id node = [[ArgumentTree alloc] initWithTree:NULL
                                                next:NULL
                                               depth:[[result objectAtIndex:i] intValue]
                                             maxsize:width[i/2]
                                                text:[result objectAtIndex:i+1]
                                               space:space
                                      mainViewBounds:r];
        [tree addObject:node];
        if (maxdepth < [[result objectAtIndex:i] intValue]) {
            maxdepth = [[result objectAtIndex:i] intValue];
        }
    }
    
    _rootNode = [tree objectAtIndex:0];
    // 木の頂点をセット.
    for (int i=0 ;i<[tree count]; i++) {
        ArgumentTree *t = [tree objectAtIndex:i];
        [t setRootNode:_rootNode];
    }
    
    // 次のノードを指定.
    for (int i=0; i<[result count]; i=i+2) {
        NSMutableArray *next = [NSMutableArray array];
        int root = [[result objectAtIndex:i] intValue];
        for (int j=i+2; j<[result count] && root!=[[result objectAtIndex:j] intValue]; j=j+2) {
            if (root+1 == [[result objectAtIndex:j] intValue]) {
                [next addObject:[tree objectAtIndex:(j/2)]];
            }
        }
        [[tree objectAtIndex:i/2] setNextTree:next];
    }
    
    // 前のノードを指定.
    int depth[maxdepth];
    for (int i=0 ; i < [result count]; i=i+2) {
        int k =[[result objectAtIndex:i] intValue];
        depth[k]=i;
        
        if (k!=0) {
            [[tree objectAtIndex:i/2] setPrevTree:[tree objectAtIndex:(depth[k-1]/2)]];
        }
    }
    [[appDelegate data] setObject:[tree objectAtIndex:0] forKey:@"rootNode"];
    CGRect rect = CGRectMake(w/2.0-size/2.0, 30, size, size);
    [[tree objectAtIndex:0] drawTree:rect mainView:_subResultView arrowImage:nil];
}

- (void)createArgumentTree:(NSMutableArray *)result :(NSString *)key
{
    // 各ノードの最大幅を規定.
    CGFloat size = 100;
    // ノード同士の幅を規定.
    int space = 30;
    srand((unsigned int)time(nil));
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect r = _scrollView.bounds;
    
    CGFloat w = r.size.width;
    
    // 各接点の最大幅を調べる.
    int width[([result count]+1)/2];
    for (int j=0; j<[result count]; j=j+2) {
        int root = [[result objectAtIndex:j] intValue];
        int max = 0;
        int prev = -1;
        for (int i=j+2; i<([result count]) && root <[[result objectAtIndex:i] intValue]; i=i+2) {
            if(prev == [[result objectAtIndex:i] intValue]){
                max++;
            }else if(prev > [[result objectAtIndex:i] intValue]){
                max++;
            }
            prev = [[result objectAtIndex:i] intValue];
        }
        max++;
        width[j/2]=max;
    }
    
    // ノードの個数によってノード同士の感覚とノード数を調整
    if ((CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])<space) {
        space = space/3;
    }
    if (size > (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])) {
        size = (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0]);
    }
    
    // 配列を木構造へ変更.
    NSMutableArray *tree = [NSMutableArray array];
    int maxdepth=0; // 最大深度
    for (int i=0; i<[result count]; i=i+2) {
        id node = [[ArgumentTree alloc] initWithTree:NULL
                                                next:NULL
                                               depth:[[result objectAtIndex:i] intValue]
                                             maxsize:width[i/2]
                                                text:[result objectAtIndex:i+1]
                                               space:space
                                      mainViewBounds:r];
        [tree addObject:node];
        if (maxdepth < [[result objectAtIndex:i] intValue]) {
            maxdepth = [[result objectAtIndex:i] intValue];
        }
    }
    
    _rootNode = [tree objectAtIndex:0];
    // 木の頂点をセット.
    for (int i=0 ;i<[tree count]; i++) {
        ArgumentTree *t = [tree objectAtIndex:i];
        [t setRootNode:_rootNode];
    }
    
    // 次のノードを指定.
    for (int i=0; i<[result count]; i=i+2) {
        NSMutableArray *next = [NSMutableArray array];
        int root = [[result objectAtIndex:i] intValue];
        for (int j=i+2; j<[result count] && root!=[[result objectAtIndex:j] intValue]; j=j+2) {
            if (root+1 == [[result objectAtIndex:j] intValue]) {
                [next addObject:[tree objectAtIndex:(j/2)]];
            }
        }
        [[tree objectAtIndex:i/2] setNextTree:next];
    }
    
    // 前のノードを指定.
    int depth[maxdepth];
    for (int i=0 ; i < [result count]; i=i+2) {
        int k =[[result objectAtIndex:i] intValue];
        depth[k]=i;
        
        if (k!=0) {
            [[tree objectAtIndex:i/2] setPrevTree:[tree objectAtIndex:(depth[k-1]/2)]];
        }
    }
    [[appDelegate data] setObject:[tree objectAtIndex:0] forKey:key];
    CGRect rect = CGRectMake(w/2.0-size/2.0, 30, size, size);
    //    [[tree objectAtIndex:0] drawTree:rect mainView:self.view];
    [[tree objectAtIndex:0] drawTree:rect mainView:_subResultView arrowImage:nil];
}

- (void)createArgumentTreeWithName:(NSMutableArray *)result
{
    // 各ノードの最大幅を規定.
    CGFloat size = 100;
    // ノード同士の幅を規定.
    int space = 30;
    srand((unsigned int)time(nil));
    CGRect r = _scrollView.bounds;
    
    CGFloat w = r.size.width;

    // 各接点の最大幅を調べる.
    int width[([result count]+1)/3];
    for (int j=0; j<[result count]; j=j+3) {
        int root = [[result objectAtIndex:j] intValue];
        int max = 0;
        int prev = -1;
        for (int i=j+3; i<([result count]) && root <[[result objectAtIndex:i] intValue]; i=i+3) {
            if(prev == [[result objectAtIndex:i] intValue]){
                max++;
            }else if(prev > [[result objectAtIndex:i] intValue]){
                max++;
            }
            prev = [[result objectAtIndex:i] intValue];
        }
        max++;
        width[j/3]=max;
    }
    
    // ノードの個数によってノード同士の間隔とノード数を調整
    if ((CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])<space) {
        space = space/3;
    }
    if (size > (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0])) {
        size = (CGFloat)((w-(space*(width[0]+1)))/(CGFloat)width[0]);
    }
    
    // 配列を木構造へ変更.
    NSMutableArray *tree = [NSMutableArray array];
    int maxdepth=0; // 最大深度
    for (int i=0; i<[result count]; i=i+3) {
        id node = [[ArgumentTree alloc] initWithTree:NULL
                                                next:NULL
                                               depth:[[result objectAtIndex:i] intValue]
                                             maxsize:width[i/3]
                                                text:[result objectAtIndex:i+2]
                                               space:space
                                      mainViewBounds:r
                                                name:[result objectAtIndex:i+1]];
        [tree addObject:node];
        if (maxdepth < [[result objectAtIndex:i] intValue]) {
            maxdepth = [[result objectAtIndex:i] intValue];
        }
    }
    
    _rootNode = [tree objectAtIndex:0];
    // 木の頂点をセット.
    for (int i=0 ;i<[tree count]; i++) {
        ArgumentTree *t = [tree objectAtIndex:i];
        [t setRootNode:_rootNode];
    }
    
    // 次のノードを指定.
    for (int i=0; i<[result count]; i=i+3) {
        NSMutableArray *next = [NSMutableArray array];
        int root = [[result objectAtIndex:i] intValue];
        for (int j=i+3; j<[result count] && root!=[[result objectAtIndex:j] intValue]; j=j+3) {
            if (root+1 == [[result objectAtIndex:j] intValue]) {
                [next addObject:[tree objectAtIndex:(j/3)]];
            }
        }
        [[tree objectAtIndex:i/3] setNextTree:next];
    }
    
    // 前のノードを指定.
    int depth[maxdepth];
    for (int i=0 ; i < [result count]; i=i+3) {
        int k =[[result objectAtIndex:i] intValue];
        depth[k]=i;
        
        if (k!=0) {
            [[tree objectAtIndex:i/3] setPrevTree:[tree objectAtIndex:(depth[k-1]/3)]];
        }
    }
    CGRect rect = CGRectMake(w/2.0-size/2.0, 100, size, size);
    //    [[tree objectAtIndex:0] drawTree:rect mainView:self.view];
    [[tree objectAtIndex:0] drawTree:rect mainView:_subResultView arrowImage:nil];
     
}

// 勝利対話木作成.
- (NSMutableArray *)createWinDialogueTree
{
    NSMutableArray *tree = [_rootNode createWinDialogueTreeRoot];
    return tree;
}

// 勝利対話木作成.
- (NSMutableArray *)createRoomWinDialogueTree
{
    NSMutableArray *tree = [_rootNode createRoomWinDialogueTreeRoot];
    return tree;
}

// ビューを1本でタップ
- (void)viewSingleTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"singletap");
    [_rootNode outputText];
    /*
    if (_scrollViewMoveFrag) {
        [self pushRightButton];
        [self.view removeGestureRecognizer:_singleTapGesture];
    }*/
}

// ビューを2本でタップ
- (void)viewDableTapped:(UITapGestureRecognizer *)sender
{
    [_rootNode undoObject];
    NSLog(@"View Dable Tapped");
}

// スクロールしている間呼ばれる
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// 拡大縮小するUIViewを指定
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _subResultView;
}

// どの方向の回転を許可するか
- (NSUInteger)supportedInterfaceOrientations {
    
    //Portrait, LandscapeLeft, LandscapeRight の場合画面回転を許可する
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WinDialogueTree";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Tree1";
    return cell;
}

// 押されたセルを判別.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}*/

- (int)getPageIndex
{
    return _index;
}

- (void)setIndex:(int)index
{
    _index = index;
}

// 右上のボタンを押したときの処理
- (void)pushRightButton
{
    if (_scrollViewMoveFrag) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             _scrollView.transform = CGAffineTransformIdentity;
//                             _winDialogueTree.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished){
                             _scrollViewMoveFrag = false;
                             [self.view removeGestureRecognizer:_singleTapGesture];
                         }];
    }else{
        CGAffineTransform trans;
        trans = CGAffineTransformMakeTranslation(-200,0);
        [UIView animateWithDuration:0.5f
                         animations:^{
                             _scrollView.transform = trans;
//                             _winDialogueTree.transform = trans;
                         } completion:^(BOOL finished){
                             _scrollViewMoveFrag = true;
                             [self.view addGestureRecognizer:_singleTapGesture];
                             
                         }];
    }
}

- (void)removeRectAndTextAndImage
{
    [_rootNode removeRectAndTextAndImage];
}
@end
