//
//  TFTCPConnection.h
//  PIRIKA
//
//  Created by katsura on 2013/05/19.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFTCPConnection : UIViewController<NSStreamDelegate>

@property (readonly, nonatomic) NSString* hostname;
@property (readonly, nonatomic) UInt32 port;
@property (nonatomic) NSInteger timeoutSec;

- (id)initWithHostname:(NSString*)hostname port:(UInt32)port timeout:(int)timeoutSec;
- (BOOL)readData:(NSMutableData*) data;
- (BOOL)writeData:(NSString *)message protocol:(int)pro;
- (BOOL)writeData:(NSString *)name :(UIImage *)img protocol:(int)pro;
- (void)closeSocket;
- (BOOL)openSocket;
@end