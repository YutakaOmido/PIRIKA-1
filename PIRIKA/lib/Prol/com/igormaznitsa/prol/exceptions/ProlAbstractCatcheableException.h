//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlAbstractCatcheableException.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlExceptionsProlAbstractCatcheableException_H_
#define _ComIgormaznitsaProlExceptionsProlAbstractCatcheableException_H_

@class ComIgormaznitsaProlDataTerm;
@class ComIgormaznitsaProlDataTermStruct;
@class JavaLangThrowable;

#import "JreEmulation.h"
#include "com/igormaznitsa/prol/exceptions/ProlException.h"

#define ComIgormaznitsaProlExceptionsProlAbstractCatcheableException_serialVersionUID 6911111912695145529LL

@interface ComIgormaznitsaProlExceptionsProlAbstractCatcheableException : ComIgormaznitsaProlExceptionsProlException {
 @public
  ComIgormaznitsaProlDataTerm *culprit_;
}

+ (long long int)serialVersionUID;
+ (ComIgormaznitsaProlDataTerm *)UNDEFINED;
- (ComIgormaznitsaProlDataTerm *)getCulprit;
- (id)initWithComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit;
- (id)initWithNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit;
- (id)initWithNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
 withJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
                    withJavaLangThrowable:(JavaLangThrowable *)cause;
- (ComIgormaznitsaProlDataTerm *)getFunctorForErrorStruct;
- (ComIgormaznitsaProlDataTermStruct *)getAsStruct;
- (void)copyAllFieldsTo:(ComIgormaznitsaProlExceptionsProlAbstractCatcheableException *)other;
@end

J2OBJC_FIELD_SETTER(ComIgormaznitsaProlExceptionsProlAbstractCatcheableException, culprit_, ComIgormaznitsaProlDataTerm *)

#endif // _ComIgormaznitsaProlExceptionsProlAbstractCatcheableException_H_
