//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlExistenceErrorException.java
//
//  Created by katsura on 14/04/13.
//

#include "IOSClass.h"
#include "IOSObjectArray.h"
#include "com/igormaznitsa/prol/data/Term.h"
#include "com/igormaznitsa/prol/data/TermStruct.h"
#include "com/igormaznitsa/prol/exceptions/ProlAbstractCatcheableException.h"
#include "com/igormaznitsa/prol/exceptions/ProlExistenceErrorException.h"
#include "java/lang/Throwable.h"

@implementation ComIgormaznitsaProlExceptionsProlExistenceErrorException

static ComIgormaznitsaProlDataTerm * ComIgormaznitsaProlExceptionsProlExistenceErrorException_ERROR_TERM_;

+ (long long int)serialVersionUID {
  return ComIgormaznitsaProlExceptionsProlExistenceErrorException_serialVersionUID;
}

+ (ComIgormaznitsaProlDataTerm *)ERROR_TERM {
  return ComIgormaznitsaProlExceptionsProlExistenceErrorException_ERROR_TERM_;
}

- (id)initWithNSString:(NSString *)objectType
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
 withJavaLangThrowable:(JavaLangThrowable *)cause {
  if (self = [super initWithComIgormaznitsaProlDataTerm:culprit withJavaLangThrowable:cause]) {
    self->objectType_ = objectType;
  }
  return self;
}

- (id)initWithNSString:(NSString *)objectType
          withNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit
 withJavaLangThrowable:(JavaLangThrowable *)cause {
  if (self = [super initWithNSString:message withComIgormaznitsaProlDataTerm:culprit withJavaLangThrowable:cause]) {
    self->objectType_ = objectType;
  }
  return self;
}

- (id)initWithNSString:(NSString *)objectType
          withNSString:(NSString *)message
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit {
  if (self = [super initWithNSString:message withComIgormaznitsaProlDataTerm:culprit]) {
    self->objectType_ = objectType;
  }
  return self;
}

- (id)initWithNSString:(NSString *)objectType
withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)culprit {
  if (self = [super initWithComIgormaznitsaProlDataTerm:culprit]) {
    self->objectType_ = objectType;
  }
  return self;
}

- (ComIgormaznitsaProlDataTerm *)getFunctorForErrorStruct {
  return ComIgormaznitsaProlExceptionsProlExistenceErrorException_ERROR_TERM_;
}

- (ComIgormaznitsaProlDataTermStruct *)getAsStruct {
  ComIgormaznitsaProlDataTermStruct *term = [[ComIgormaznitsaProlDataTermStruct alloc] initWithNSString:objectType_ withComIgormaznitsaProlDataTermArray:[IOSObjectArray arrayWithObjects:(id[]){ objectType_ == nil ? [ComIgormaznitsaProlExceptionsProlAbstractCatcheableException UNDEFINED] : [[ComIgormaznitsaProlDataTerm alloc] initWithNSString:objectType_], [self getCulprit] == nil ? [ComIgormaznitsaProlExceptionsProlAbstractCatcheableException UNDEFINED] : [self getCulprit] } count:2 type:[IOSClass classWithClass:[ComIgormaznitsaProlDataTerm class]]]];
  [term setCarriedObjectWithJavaIoSerializable:self];
  return term;
}

+ (void)initialize {
  if (self == [ComIgormaznitsaProlExceptionsProlExistenceErrorException class]) {
    ComIgormaznitsaProlExceptionsProlExistenceErrorException_ERROR_TERM_ = [[ComIgormaznitsaProlDataTerm alloc] initWithNSString:@"existence_error"];
  }
}

- (void)copyAllFieldsTo:(ComIgormaznitsaProlExceptionsProlExistenceErrorException *)other {
  [super copyAllFieldsTo:other];
  other->objectType_ = objectType_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithNSString:withComIgormaznitsaProlDataTerm:withJavaLangThrowable:", "ProlExistenceErrorException", NULL, 0x1, NULL },
    { "initWithNSString:withNSString:withComIgormaznitsaProlDataTerm:withJavaLangThrowable:", "ProlExistenceErrorException", NULL, 0x1, NULL },
    { "initWithNSString:withNSString:withComIgormaznitsaProlDataTerm:", "ProlExistenceErrorException", NULL, 0x1, NULL },
    { "initWithNSString:withComIgormaznitsaProlDataTerm:", "ProlExistenceErrorException", NULL, 0x1, NULL },
    { "getFunctorForErrorStruct", NULL, "Lcom.igormaznitsa.prol.data.Term;", 0x1, NULL },
    { "getAsStruct", NULL, "Lcom.igormaznitsa.prol.data.TermStruct;", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "serialVersionUID_", NULL, 0x1a, "J" },
    { "ERROR_TERM_", NULL, 0x1a, "Lcom.igormaznitsa.prol.data.Term;" },
    { "objectType_", NULL, 0x12, "Ljava.lang.String;" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlExceptionsProlExistenceErrorException = { "ProlExistenceErrorException", "com.igormaznitsa.prol.exceptions", NULL, 0x1, 6, methods, 3, fields, 0, NULL};
  return &_ComIgormaznitsaProlExceptionsProlExistenceErrorException;
}

@end
