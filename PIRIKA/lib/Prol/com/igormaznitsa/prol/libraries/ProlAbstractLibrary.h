//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/libraries/ProlAbstractLibrary.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlLibrariesProlAbstractLibrary_H_
#define _ComIgormaznitsaProlLibrariesProlAbstractLibrary_H_

@class ComIgormaznitsaProlAnnotationsProlOperator;
@class ComIgormaznitsaProlContainersOperatorContainer;
@class ComIgormaznitsaProlDataTermStruct;
@class ComIgormaznitsaProlLibrariesPredicateProcessor;
@class ComIgormaznitsaProlLogicProlContext;
@protocol JavaUtilMap;

#import "JreEmulation.h"

@interface ComIgormaznitsaProlLibrariesProlAbstractLibrary : NSObject {
 @public
  id<JavaUtilMap> libraryOperators_;
  NSString *libraryUID_;
  id<JavaUtilMap> predicateMethodsMap_;
}

- (id)initWithNSString:(NSString *)libraryID;
- (BOOL)hasPredicateForSignatureWithNSString:(NSString *)signature;
- (ComIgormaznitsaProlLibrariesPredicateProcessor *)findProcessorForPredicateWithComIgormaznitsaProlDataTermStruct:(ComIgormaznitsaProlDataTermStruct *)predicate;
- (NSString *)getLibraryUID;
- (void)release__;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)obj;
- (void)scanThisClassForPredicates;
- (void)addStaticOperatorWithComIgormaznitsaProlAnnotationsProlOperator:(ComIgormaznitsaProlAnnotationsProlOperator *)operator_;
- (void)loadStaticOperators;
- (BOOL)isSystemOperatorWithNSString:(NSString *)nameToBeChecked;
- (BOOL)hasSyatemOperatorStartsWithWithNSString:(NSString *)startSubstring;
- (ComIgormaznitsaProlContainersOperatorContainer *)findSystemOperatorForNameWithNSString:(NSString *)operatorName;
- (void)contextHasBeenHaltedWithComIgormaznitsaProlLogicProlContext:(ComIgormaznitsaProlLogicProlContext *)context;
- (void)copyAllFieldsTo:(ComIgormaznitsaProlLibrariesProlAbstractLibrary *)other;
@end

J2OBJC_FIELD_SETTER(ComIgormaznitsaProlLibrariesProlAbstractLibrary, libraryOperators_, id<JavaUtilMap>)
J2OBJC_FIELD_SETTER(ComIgormaznitsaProlLibrariesProlAbstractLibrary, libraryUID_, NSString *)
J2OBJC_FIELD_SETTER(ComIgormaznitsaProlLibrariesProlAbstractLibrary, predicateMethodsMap_, id<JavaUtilMap>)

#endif // _ComIgormaznitsaProlLibrariesProlAbstractLibrary_H_
