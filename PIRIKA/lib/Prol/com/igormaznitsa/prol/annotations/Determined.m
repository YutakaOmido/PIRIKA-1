//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/annotations/Determined.java
//
//  Created by katsura on 14/04/13.
//

#include "IOSClass.h"
#include "com/igormaznitsa/prol/annotations/Determined.h"
#include "java/lang/annotation/ElementType.h"
#include "java/lang/annotation/Retention.h"
#include "java/lang/annotation/RetentionPolicy.h"
#include "java/lang/annotation/Target.h"

@implementation ComIgormaznitsaProlAnnotationsDetermined
- (IOSClass *)annotationType {
  return [IOSClass classWithProtocol:@protocol(ComIgormaznitsaProlAnnotationsDetermined)];
}

+ (IOSObjectArray *)__annotations {
  return [IOSObjectArray arrayWithObjects:(id[]) { [[JavaLangAnnotationTarget alloc] initWithValue:[IOSObjectArray arrayWithObjects:(id[]) { [JavaLangAnnotationElementTypeEnum METHOD] } count:1 type:[[NSObject class] getClass]]], [[JavaLangAnnotationRetention alloc] initWithValue:[JavaLangAnnotationRetentionPolicyEnum RUNTIME]] } count:2 type:[IOSClass classWithProtocol:@protocol(JavaLangAnnotationAnnotation)]];
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcClassInfo _ComIgormaznitsaProlAnnotationsDetermined = { "Determined", "com.igormaznitsa.prol.annotations", NULL, 0x2201, 0, NULL, 0, NULL, 0, NULL};
  return &_ComIgormaznitsaProlAnnotationsDetermined;
}

@end
