//
//  AppDelegate.m
//  PIRIKA
//
//  Created by katsura on 2014/01/06.
//  Copyright (c) 2014年 katsura. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
    
    // 初めて起動した場合.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    _data = [NSMutableDictionary dictionary];
    UIImage *img = [self loadImage:@"self.jpg"];
    if (img==Nil) {
        UIImage *img = [self loadImage:@"user1.png"];
        [self saveImage:img fileName:@"self.jpg"];
    }
    [self readInitFile];
    NSArray *ar = [NSArray arrayWithObjects:@"01Value", @"2Value", @"4Value", @"7Value", @"IntValue",nil];
    for (NSString *path in ar) {
        [self createDirectory:path];
    }
    return YES;
}
    
    // 非アクティブになる直前.
- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveData];
}
    
    //アプリが非Activeになりバックグランド実行になった.
- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
    
    // 2回目以降の起動時に呼び出される.
- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
    
    // アプリがActiveになった際に呼び出される.
- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
    
    // アプリケーション終了時.
- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
    // ファイルへ書き出し.
- (void)saveData{
    NSString *str = [_data objectForKey:@"userName"];
    [self writeData:str];
    str = [_data objectForKey:@"ip"];
    [self writeAddData:str];
    str = [_data objectForKey:@"port"];
    [self writeAddData:str];
}
    
    // ファイルに初期設定を書き込む.(CreateFile)
- (void)writeData:(NSString *)str{
    NSFileHandle *handle;
    str = [str stringByAppendingString:@"\n"];
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:@"setting.ini"];
        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:nil
                                              attributes:nil];
        handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
        [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }@finally {
        [handle closeFile];
    }
}
    // ファイルに初期設定を書き込む.(AddData)
- (void)writeAddData:(NSString *)str{
    NSFileHandle *handle;
    str = [str stringByAppendingString:@"\n"];
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:@"setting.ini"];
        handle=[NSFileHandle fileHandleForWritingAtPath:filePath];
        [handle seekToEndOfFile];
        [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }@finally {
        [handle closeFile];
    }
}
    
    // ユーザの設定データを読み出す
- (void)readInitFile{
    NSFileHandle *handle;
    @try {
        NSString* a_home_dir = NSHomeDirectory();
        NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
        NSString *filePath=[a_doc_dir stringByAppendingPathComponent:@"setting.ini"];
        handle=[NSFileHandle fileHandleForReadingAtPath:filePath];
        
        
        if (handle) {
            NSData *data=[handle readDataToEndOfFile];
            NSString* text=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *lines = [text componentsSeparatedByString:@"\n"];
            [_data setObject:lines[0] forKey:@"userName"];
            [_data setObject:lines[1] forKey:@"ip"];
            [_data setObject:lines[2] forKey:@"port"];
        }else{
            [self setUserName];
            [_data setObject:@"pirika.cs.ie.niigata-u.ac.jp" forKey:@"ip"];
            [_data setObject:@"51984" forKey:@"port"];
        }
        
    }@finally {
        [handle closeFile];
    }
}
    
// user名を入力するアラート表示.
-(void)setUserName{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"User Name"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    message.tag = 0;
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];//１行で実装
    [message show];
}
    
    // OKボタンを押せるかどうか
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (alertView.tag==0) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        // $ は禁止文字
        if( [inputText length] >= 1
           && ([inputText rangeOfString:@"$"].location == NSNotFound)
           && ([inputText rangeOfString:@":"].location == NSNotFound)
           && ([inputText rangeOfString:@";"].location == NSNotFound)
           && ([inputText rangeOfString:@"/"].location == NSNotFound)
           && ([inputText rangeOfString:@"\\"].location == NSNotFound)
           && ([inputText rangeOfString:@"|"].location == NSNotFound)
           && ([inputText rangeOfString:@","].location == NSNotFound)
           && ([inputText rangeOfString:@"*"].location == NSNotFound)
           && ([inputText rangeOfString:@"?"].location == NSNotFound)
           && ([inputText rangeOfString:@"\""].location == NSNotFound)
           && ([inputText rangeOfString:@"<"].location == NSNotFound)
           && ([inputText rangeOfString:@">"].location == NSNotFound)
           && ([inputText rangeOfString:@"."].location == NSNotFound)){
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}
    
    // アラートフィールドに入力した文字列を取得する
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==0) {
            NSString *str;
            str = [[alertView textFieldAtIndex:0] text];
            [_data setObject:str forKey:@"userName"];
        }
    }
}
    
- (UIImage *)loadImage:(NSString *)str{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];
    return [UIImage imageWithContentsOfFile:filePath];
}
    
- (BOOL)saveImage:(UIImage *)img fileName:(NSString *)str{
    NSData *data = UIImageJPEGRepresentation(img,1.0);
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];
    
    if ([data writeToFile:filePath atomically:YES]) {
        return true;
    } else {
        return false;
    }
}
    
- (void)createDirectory:(NSString *)directory{
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    a_doc_dir = [a_doc_dir stringByAppendingPathComponent:directory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:a_doc_dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:a_doc_dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
}
    @end
