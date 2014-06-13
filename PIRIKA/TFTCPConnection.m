//
//  TFTCPConnection.m
//  PIRIKA
//
//  Created by katsura on 2013/05/19.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "TFTCPConnection.h"
#import "AppDelegate.h"

@implementation TFTCPConnection{
    dispatch_semaphore_t _semaphore;
    
    NSInputStream* _readStream;
    NSOutputStream* _writeStream;
}
    
    
- (id)initWithHostname:(NSString*)hostname port:(UInt32)port timeout:(int)timeoutSec{
    self = [super init];
    if(self){
        _hostname = hostname;
        _port = port;
        _timeoutSec = timeoutSec;
        
        _readStream = nil;
        _writeStream = nil;
    }
    return self;
}
    
    
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    assert(aStream == _readStream || aStream == _writeStream);
//    NSLog(@"handleEvent: %u",eventCode);8
    dispatch_semaphore_signal(_semaphore);
}
    
- (dispatch_time_t)innerDispatch_time{
    if(_timeoutSec > 0){
        return dispatch_time(DISPATCH_TIME_NOW, (_timeoutSec * NSEC_PER_SEC));
    }else if(_timeoutSec == 0){
        return DISPATCH_TIME_NOW;
    }else{
        return DISPATCH_TIME_FOREVER;
    }
}
    
- (BOOL)openSocket{
    BOOL ret = NO;
    
    if(_semaphore) return ret;
    _semaphore = dispatch_semaphore_create(0);
    //dispatch_retain(_semaphore);
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)_hostname,  _port, &readStream,&writeStream);
    
    _readStream = (__bridge_transfer NSInputStream*)readStream;
    _readStream.delegate = self;
    [_readStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    _writeStream = (__bridge_transfer NSOutputStream*)writeStream;
    _writeStream.delegate = self;
    [_writeStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_readStream open];
    [_writeStream open];
    
    dispatch_time_t timeout = [self innerDispatch_time];
    // 読み込みストリームオープン検査
    while(TRUE){
        NSStreamStatus stat = _readStream.streamStatus;
        NSLog(@"_readStream.streamStatus %u",stat);
        NSLog(@"_readStream.streamStatus %u",NSStreamStatusOpen);
        if(stat == NSStreamStatusOpen){
            NSLog(@"_readStream open");
            break;
        }else if(stat != NSStreamStatusOpening){
            return ret; // エラー
        }
        if(dispatch_semaphore_wait(_semaphore, timeout)) return ret;
    }
    //  書き出しストリームオープン検査
    while(TRUE){
        NSStreamStatus stat = _writeStream.streamStatus;
        NSLog(@"_writeStream.streamStatus %u",stat);
        if(stat == NSStreamStatusOpen){
            NSLog(@"_writeStream open");
            break;
        }else if(stat != NSStreamStatusOpening){
            return ret; // エラー
        }
        if(dispatch_semaphore_wait(_semaphore, timeout)) return ret;
    }
    return YES;
}
    
- (void)closeSocket{
    if(_writeStream){
        _writeStream.delegate = nil;
        [_writeStream close];
        [_writeStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _writeStream = nil;
    }
    if(_readStream){
        _readStream.delegate = nil;
        [_readStream close];
        [_readStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _readStream = nil;
    }
    if(_semaphore){
        //dispatch_release(_semaphore);
        _semaphore = nil;
    }
}
    
- (BOOL)readData:(NSMutableData*)data length:(NSUInteger)len{
    BOOL ret = NO;
    NSInteger leftlen = len;
    if(leftlen <= 0) return YES;
    dispatch_time_t timeout = [self innerDispatch_time];
    while(TRUE){
        NSStreamStatus stat = _readStream.streamStatus;
        if(stat == NSStreamStatusOpen || stat == NSStreamStatusReading){
            if([_readStream hasBytesAvailable]){
                // 読み込み可能
                uint8_t buf[1024];
                NSInteger maxlen = (sizeof(buf) / sizeof(uint8_t)); // バッファサイズ
                if(maxlen > leftlen) maxlen = leftlen;
                NSInteger count = [_readStream read:buf maxLength:maxlen];
                if(count > 0){
                    [data appendBytes:buf length:count];
                    leftlen -= count;
                    if(leftlen <= 0){
                        // 指定バイト読み込めたので終了
                        ret = YES;
                        break;
                    }
                }else{
                    if(count == 0){
                        NSLog(@"readData eof");
                    }else{
                        NSLog(@"readData error %@",_readStream.streamError.description);
                    }
                    break;
                }
            }
        }else{
//            NSLog(@"readData error %u",stat);
            break; // エラー
        }
        if(dispatch_semaphore_wait(_semaphore, timeout)){
            NSLog(@"readData timeout");
            break;
        }
    }
    return ret;
}
    
- (BOOL)readLength:(NSMutableData*)data{
    BOOL ret = NO;
    NSInteger leftlen = 4;
    if(leftlen <= 0) return YES;
    dispatch_time_t timeout = [self innerDispatch_time];
    while(TRUE){
        NSStreamStatus stat = _readStream.streamStatus;
        if(stat == NSStreamStatusOpen || stat == NSStreamStatusReading){
            if([_readStream hasBytesAvailable]){
                // 読み込み可能
                uint8_t buf[4];
                NSInteger maxlen = (sizeof(buf) / sizeof(uint8_t)); // バッファサイズ
                if(maxlen > leftlen) maxlen = leftlen;
                NSInteger count = [_readStream read:buf maxLength:maxlen];
                if(count > 0){
                    [data appendBytes:buf length:count];
                    leftlen -= count;
                    if(leftlen <= 0){
                        // 指定バイト読み込めたので終了
                        ret = YES;
                        break;
                    }
                }else{
                    if(count == 0){
                        NSLog(@"readData eof");
                    }else{
                        NSLog(@"readData error %@",_readStream.streamError.description);
                    }
                    break;
                }
            }
        }else{
//            NSLog(@"readData error %u",stat);
            break; // エラー
        }
        if(dispatch_semaphore_wait(_semaphore, timeout)){
            NSLog(@"readData timeout");
            break;
        }
    }
    return ret;
}
    
- (BOOL)writeData:(const void*)data length:(NSUInteger)len{
    BOOL ret = NO;
    NSInteger leftlen = len;
    if(leftlen <= 0) return YES;
    dispatch_time_t timeout = [self innerDispatch_time];
    while(TRUE){
        NSStreamStatus stat = _writeStream.streamStatus;
        if(stat == NSStreamStatusOpen || stat == NSStreamStatusWriting){
            if([_writeStream hasSpaceAvailable]){
                // 書き出し可能
                NSInteger count = [_writeStream write:(data + (len - leftlen)) maxLength:leftlen];
                if(count >= 0){
                    leftlen -= count;
                    if(leftlen <= 0){
                        ret = YES;
                        break;
                    }
                }else{
                    NSLog(@"writeData error %@",_writeStream.streamError.description);
                    break;
                }
            }
        }else{
//            NSLog(@"writeData error %u",stat);
            break; // エラー
        }
        if(dispatch_semaphore_wait(_semaphore, timeout)){
            NSLog(@"writeData timeout");
            break;
        }
    }
    return ret;
}
    
- (BOOL)writeData:(NSString *)message protocol:(int)pro{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    unsigned int swapval = NSSwapHostIntToBig(((unsigned int)len)+4);
    unsigned int swappro = NSSwapHostIntToBig(pro);
    if([self writeData:&swapval length:4]){
        if ([self writeData:&swappro length:4]) {
            if([self writeData:byteData length:len]){
#if DEBUG
                NSLog(@"writeData success");
#endif
            }else{
#if DEBUG
                NSLog(@"writeData failure");
#endif
                return false;
            }
        }else{
            return false;
        }
    }else{
#if DEBUG
        NSLog(@"writeData failure");
#endif
    }
    return true;
}

- (BOOL)writeData:(NSString *)name :(UIImage *)img protocol:(int)pro{
    NSMutableData *data = [NSMutableData data];
    [data appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *imgdata = UIImageJPEGRepresentation(img,1.0);
    [data appendData:imgdata];
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    unsigned int swapval = NSSwapHostIntToBig(((unsigned int)len)+4);
    unsigned int swappro = NSSwapHostIntToBig(pro);
    if([self writeData:&swapval length:4]){
        if ([self writeData:&swappro length:4]) {
            if([self writeData:byteData length:len]){
#if DEBUG
                NSLog(@"writeData success");
#endif
            }else{
#if DEBUG
                NSLog(@"writeData failure");
#endif
                return false;
            }
        }else{
            return false;
        }
    }else{
#if DEBUG
        NSLog(@"writeData failure");
#endif
    }
    return true;
}
    
- (BOOL)readData:(NSMutableData*) data{
    NSMutableData *len = [NSMutableData data];
    if([self readLength:len]){
#if DEBUG
        NSLog(@"readData success");
#endif
        int k=0;
        [len getBytes:&k length:4];
        k = [self swapIntByteOrder:k];
        if([self readData:data length:k-4]){
#if DEBUG
            NSLog(@"readData success");
#endif
        }else{
#if DEBUG
            NSLog(@"readData failure");
#endif
        }
    }else{
#if DEBUG
        NSLog(@"readData failure");
#endif
    }
    return true;
}
    
- (NSString*) serializeDeviceToken:(NSData*) deviceToken{
    NSMutableString *str = [NSMutableString stringWithCapacity:64];
    int length = (int)[deviceToken length];
    char *bytes = malloc(sizeof(char) * length);
    
    [deviceToken getBytes:bytes length:length];
    
    for (int i = 0; i < length; i++)
    {
        [str appendFormat:@"%02.2hhX", bytes[i]];
        
    }
    free(bytes);
    
    return str;
}

- (int)toInt:(NSData*) deviceToken{
    char *bytes = malloc(sizeof(char) * 4);
    NSMutableString *str = [NSMutableString stringWithCapacity:64];
    [deviceToken getBytes:bytes length:4];
    int k = 0;
    
    for (int i = 3; i >= 0; i--)
    {
        [str appendFormat:@"%02.2hhX", bytes[i]];
        k = k ^ (bytes[i]<<(8*(3-i)));
    }
    free(bytes);
    return k;
}

- (unsigned short)swapShortByteOrder:(unsigned short) n{
    return (n << 8) | (n >> 8);
}
    
-(unsigned int)swapIntByteOrder:(unsigned int) n{
    return [self swapShortByteOrder:(n >> 16)] | ([self swapShortByteOrder:n] << 16);
}
    
@end
