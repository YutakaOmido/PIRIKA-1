//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/io/ProlTextWriter.java
//
//  Created by katsura on 14/04/13.
//

#include "IOSClass.h"
#include "com/igormaznitsa/prol/data/Term.h"
#include "com/igormaznitsa/prol/io/ProlTextWriter.h"
#include "java/io/IOException.h"


@interface ComIgormaznitsaProlIoProlTextWriter : NSObject
@end

@implementation ComIgormaznitsaProlIoProlTextWriter

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "writeTermWithComIgormaznitsaProlDataTerm:", "writeTerm", "V", 0x401, "Ljava.io.IOException;" },
    { "writeCharWithComIgormaznitsaProlDataTerm:", "writeChar", "V", 0x401, "Ljava.io.IOException;" },
    { "getResourceId", NULL, "Ljava.lang.String;", 0x401, NULL },
    { "close", NULL, "V", 0x401, "Ljava.io.IOException;" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlIoProlTextWriter = { "ProlTextWriter", "com.igormaznitsa.prol.io", NULL, 0x201, 4, methods, 0, NULL, 0, NULL};
  return &_ComIgormaznitsaProlIoProlTextWriter;
}

@end
