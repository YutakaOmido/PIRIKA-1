//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/io/ProlTextReader.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlIoProlTextReader_H_
#define _ComIgormaznitsaProlIoProlTextReader_H_

@class ComIgormaznitsaProlDataTerm;
@class ComIgormaznitsaProlDataTermInteger;

#import "JreEmulation.h"

@protocol ComIgormaznitsaProlIoProlTextReader < NSObject, JavaObject >
- (ComIgormaznitsaProlDataTerm *)readToken;
- (ComIgormaznitsaProlDataTerm *)readTerm;
- (ComIgormaznitsaProlDataTermInteger *)readChar;
- (NSString *)getResourceId;
- (void)close;
@end

#endif // _ComIgormaznitsaProlIoProlTextReader_H_
