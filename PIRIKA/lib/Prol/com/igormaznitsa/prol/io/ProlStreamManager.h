//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/io/ProlStreamManager.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlIoProlStreamManager_H_
#define _ComIgormaznitsaProlIoProlStreamManager_H_

@class JavaIoReader;
@class JavaIoWriter;

#import "JreEmulation.h"

@protocol ComIgormaznitsaProlIoProlStreamManager < NSObject, JavaObject >
- (JavaIoReader *)getReaderForResourceWithNSString:(NSString *)resourceName;
- (JavaIoWriter *)getWriterForResourceWithNSString:(NSString *)resourceName
                                       withBoolean:(BOOL)append;
@end

#endif // _ComIgormaznitsaProlIoProlStreamManager_H_