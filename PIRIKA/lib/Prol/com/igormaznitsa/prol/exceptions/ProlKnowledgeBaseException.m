//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlKnowledgeBaseException.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/exceptions/ProlKnowledgeBaseException.h"
#include "java/lang/Throwable.h"

@implementation ComIgormaznitsaProlExceptionsProlKnowledgeBaseException

+ (long long int)serialVersionUID {
  return ComIgormaznitsaProlExceptionsProlKnowledgeBaseException_serialVersionUID;
}

- (id)init {
  return [super init];
}

- (id)initWithNSString:(NSString *)message {
  return [super initWithNSString:message];
}

- (id)initWithNSString:(NSString *)message
 withJavaLangThrowable:(JavaLangThrowable *)cause {
  return [super initWithNSString:message withJavaLangThrowable:cause];
}

- (id)initWithJavaLangThrowable:(JavaLangThrowable *)cause {
  return [super initWithJavaLangThrowable:cause];
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "init", "ProlKnowledgeBaseException", NULL, 0x1, NULL },
    { "initWithNSString:", "ProlKnowledgeBaseException", NULL, 0x1, NULL },
    { "initWithNSString:withJavaLangThrowable:", "ProlKnowledgeBaseException", NULL, 0x1, NULL },
    { "initWithJavaLangThrowable:", "ProlKnowledgeBaseException", NULL, 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "serialVersionUID_", NULL, 0x1a, "J" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlExceptionsProlKnowledgeBaseException = { "ProlKnowledgeBaseException", "com.igormaznitsa.prol.exceptions", NULL, 0x1, 4, methods, 1, fields, 0, NULL};
  return &_ComIgormaznitsaProlExceptionsProlKnowledgeBaseException;
}

@end
