//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlExistenceErrorException.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlExceptionsProlExistenceErrorException_H_
#define _ComIgormaznitsaProlExceptionsProlExistenceErrorException_H_

@class ComIgormaznitsaProlDataTerm;
@class ComIgormaznitsaProlDataTermStruct;
@class JavaLangThrowable;

#import "JreEmulation.h"
#include "com/igormaznitsa/prol/exceptions/ProlAbstractCatcheableException.h"

#define ComIgormaznitsaProlExceptionsProlExistenceErrorException_serialVersionUID 8133227498750254779LL

@interface ComIgormaznitsaProlExceptionsProlExistenceErrorException : ComIgormaznitsaProlExceptionsProlAbstractCatcheableException {
 @public
  NSString *objectType_;
}

+ (long long int)serialVersionUID;
+ (ComIgormaznitsaProlDataTerm *)ERROR_TERM;
- (id)initWithNSString:(NSString *)objectType
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
 withJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithNSString:(NSString *)objectType
          withNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
 withJavaLangThrowable:(JavaLangThrowable *)cause;
- (id)initWithNSString:(NSString *)objectType
          withNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit;
- (id)initWithNSString:(NSString *)objectType
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit;
- (ComIgormaznitsaProlDataTerm *)getFunctorForErrorStruct;
- (ComIgormaznitsaProlDataTermStruct *)getAsStruct;
- (void)copyAllFieldsTo:(ComIgormaznitsaProlExceptionsProlExistenceErrorException *)other;
@end

J2OBJC_FIELD_SETTER(ComIgormaznitsaProlExceptionsProlExistenceErrorException, objectType_, NSString *)

#endif // _ComIgormaznitsaProlExceptionsProlExistenceErrorException_H_
