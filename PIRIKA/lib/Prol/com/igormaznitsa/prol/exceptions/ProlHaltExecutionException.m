//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/exceptions/ProlHaltExecutionException.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/exceptions/ProlHaltExecutionException.h"

@implementation ComIgormaznitsaProlExceptionsProlHaltExecutionException

+ (long long int)serialVersionUID {
  return ComIgormaznitsaProlExceptionsProlHaltExecutionException_serialVersionUID;
}

- (id)init {
  if (self = [super initWithNSString:@"The program is halted."]) {
    self->status_ = 0;
  }
  return self;
}

- (id)initWithInt:(int)status {
  if (self = [super initWithNSString:@"The program is halted."]) {
    self->status_ = status;
  }
  return self;
}

- (id)initWithNSString:(NSString *)cause
               withInt:(int)status {
  if (self = [super initWithNSString:cause]) {
    self->status_ = status;
  }
  return self;
}

- (int)getStatus {
  return self->status_;
}

- (void)copyAllFieldsTo:(ComIgormaznitsaProlExceptionsProlHaltExecutionException *)other {
  [super copyAllFieldsTo:other];
  other->status_ = status_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "init", "ProlHaltExecutionException", NULL, 0x1, NULL },
    { "initWithInt:", "ProlHaltExecutionException", NULL, 0x1, NULL },
    { "initWithNSString:withInt:", "ProlHaltExecutionException", NULL, 0x1, NULL },
    { "getStatus", NULL, "I", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "serialVersionUID_", NULL, 0x1a, "J" },
    { "status_", NULL, 0x12, "I" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlExceptionsProlHaltExecutionException = { "ProlHaltExecutionException", "com.igormaznitsa.prol.exceptions", NULL, 0x1, 4, methods, 2, fields, 0, NULL};
  return &_ComIgormaznitsaProlExceptionsProlHaltExecutionException;
}

@end