//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/libraries/ProlLibraryWrapper.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlLibrariesProlLibraryWrapper_H_
#define _ComIgormaznitsaProlLibrariesProlLibraryWrapper_H_

@class ComIgormaznitsaProlDataTerm;
@class ComIgormaznitsaProlDataTermStruct;
@class ComIgormaznitsaProlLogicGoal;
@class ComIgormaznitsaProlLogicProlContext;
@class IOSClass;
@class JavaLangReflectMethod;
@class JavaUtilLoggingLogger;
@protocol JavaUtilMap;

#import "JreEmulation.h"
#include "com/igormaznitsa/prol/libraries/ProlAbstractLibrary.h"

@interface ComIgormaznitsaProlLibrariesProlLibraryWrapper : ComIgormaznitsaProlLibrariesProlAbstractLibrary {
 @public
  id wrappedObject_;
  id<JavaUtilMap> methodMap_;
}

+ (JavaUtilLoggingLogger *)LOG;
+ (JavaLangReflectMethod *)EVAL_PREDICATE_HANDLER;
+ (JavaLangReflectMethod *)PREDICATE_HANDLER;
- (id)initWithNSString:(NSString *)libId
                withId:(id)wrappedObj;
- (id)getWrappedObject;
+ (ComIgormaznitsaProlLibrariesProlLibraryWrapper *)makeWrapperWithId:(id)wrappedObj;
- (void)fillPredicateTable;
- (id)handlePredicateWithComIgormaznitsaProlLogicGoal:(ComIgormaznitsaProlLogicGoal *)goal
                withComIgormaznitsaProlDataTermStruct:(ComIgormaznitsaProlDataTermStruct *)predicate;
- (ComIgormaznitsaProlDataTerm *)proxyEvaluablePredicateWithComIgormaznitsaProlLogicGoal:(ComIgormaznitsaProlLogicGoal *)goal
                                                   withComIgormaznitsaProlDataTermStruct:(ComIgormaznitsaProlDataTermStruct *)predicate;
- (BOOL)proxyPredicateWithComIgormaznitsaProlLogicGoal:(ComIgormaznitsaProlLogicGoal *)goal
                 withComIgormaznitsaProlDataTermStruct:(ComIgormaznitsaProlDataTermStruct *)predicate;
+ (BOOL)checkNameForValidityWithNSString:(NSString *)name;
+ (NSString *)generatePredicateNameFromMethodNameWithJavaLangReflectMethod:(JavaLangReflectMethod *)method;
+ (void)setObjectToArrayElementWithId:(id)array
                              withInt:(int)index
                               withId:(id)element;
+ (id)newArrayWithIOSClass:(IOSClass *)type
                   withInt:(int)length OBJC_METHOD_FAMILY_NONE;
+ (id)term2objWithComIgormaznitsaProlLogicProlContext:(ComIgormaznitsaProlLogicProlContext *)context
                                         withIOSClass:(IOSClass *)argclass
                      withComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)term;
- (void)copyAllFieldsTo:(ComIgormaznitsaProlLibrariesProlLibraryWrapper *)other;
@end

J2OBJC_FIELD_SETTER(ComIgormaznitsaProlLibrariesProlLibraryWrapper, wrappedObject_, id)
J2OBJC_FIELD_SETTER(ComIgormaznitsaProlLibrariesProlLibraryWrapper, methodMap_, id<JavaUtilMap>)

#endif // _ComIgormaznitsaProlLibrariesProlLibraryWrapper_H_