//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlKnowledgeBaseException.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlExceptionsProlKnowledgeBaseException_H_
#define _ComIgormaznitsaProlExceptionsProlKnowledgeBaseException_H_

@class JavaLangThrowable;

#import "JreEmulation.h"
#include "com/igormaznitsa/prol/exceptions/ProlException.h"

#define ComIgormaznitsaProlExceptionsProlKnowledgeBaseException_serialVersionUID 7055306365499059734LL

@interface ComIgormaznitsaProlExceptionsProlKnowledgeBaseException : ComIgormaznitsaProlExceptionsProlException {
}

+ (long long int)serialVersionUID;
- (id)init;
- (id)initWithNSString:(NSString *)message;
- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithJavaLangThrowable:(JavaLangThrowable *)cause;
@end

#endif // _ComIgormaznitsaProlExceptionsProlKnowledgeBaseException_H_