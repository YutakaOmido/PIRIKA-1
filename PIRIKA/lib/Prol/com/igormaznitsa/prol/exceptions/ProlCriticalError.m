//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlCriticalError.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/exceptions/ProlCriticalError.h"
#include "java/lang/Throwable.h"

@implementation ComIgormaznitsaProlExceptionsProlCriticalError

+ (long long int)serialVersionUID {
  return ComIgormaznitsaProlExceptionsProlCriticalError_serialVersionUID;
}

- (id)initWithJavaLangThrowable:(JavaLangThrowable *)cause {
  return [super initWithJavaLangThrowable:cause];
}

- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)cause {
  return [super initWithNSString:message withJavaLangThrowable:cause];
}

- (id)initWithNSString:(NSString *)message {
  return [super initWithNSString:message];
}

- (id)init {
  return [super init];
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithJavaLangThrowable:", "ProlCriticalError", NULL, 0x1, NULL },
    { "initWithNSString:withJavaLangThrowable:", "ProlCriticalError", NULL, 0x1, NULL },
    { "initWithNSString:", "ProlCriticalError", NULL, 0x1, NULL },
    { "init", "ProlCriticalError", NULL, 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "serialVersionUID_", NULL, 0x1a, "J" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlExceptionsProlCriticalError = { "ProlCriticalError", "com.igormaznitsa.prol.exceptions", NULL, 0x1, 4, methods, 1, fields, 0, NULL};
  return &_ComIgormaznitsaProlExceptionsProlCriticalError;
}

@end
