//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/annotations/ProlOperator.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/annotations/ProlOperator.h"

@implementation ComIgormaznitsaProlAnnotationsProlOperator

- (id)initWithInt:(int)Priority
          withInt:(int)Type
     withNSString:(NSString *)Name {
  if (self = [super init]) {
    self->Priority__ = Priority;
    self->Type__ = Type;
    self->Name__ = Name;
  }
  return self;
}

- (void)setPriorityWithInt:(int)p {
  self->Priority__ = p;
}

- (int)Priority {
  return self->Priority__;
}

- (void)setTypeWithInt:(int)s {
  self->Type__ = s;
}

- (int)Type {
  return self->Type__;
}

- (void)setNameWithNSString:(NSString *)n {
  self->Name__ = n;
}

- (NSString *)Name {
  return Name__;
}

- (void)copyAllFieldsTo:(ComIgormaznitsaProlAnnotationsProlOperator *)other {
  [super copyAllFieldsTo:other];
  other->Name__ = Name__;
  other->Priority__ = Priority__;
  other->Type__ = Type__;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithInt:withInt:withNSString:", "ProlOperator", NULL, 0x1, NULL },
    { "setPriorityWithInt:", "setPriority", "V", 0x1, NULL },
    { "Priority", NULL, "I", 0x1, NULL },
    { "setTypeWithInt:", "setType", "V", 0x1, NULL },
    { "Type", NULL, "I", 0x1, NULL },
    { "setNameWithNSString:", "setName", "V", 0x1, NULL },
    { "Name", NULL, "Ljava.lang.String;", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "Priority__", "Priority", 0x0, "I" },
    { "Type__", "Type", 0x0, "I" },
    { "Name__", "Name", 0x0, "Ljava.lang.String;" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlAnnotationsProlOperator = { "ProlOperator", "com.igormaznitsa.prol.annotations", NULL, 0x1, 7, methods, 3, fields, 0, NULL};
  return &_ComIgormaznitsaProlAnnotationsProlOperator;
}

@end
