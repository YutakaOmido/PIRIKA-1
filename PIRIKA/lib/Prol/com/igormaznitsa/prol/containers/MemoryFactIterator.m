//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/containers/MemoryFactIterator.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/containers/InsideClauseListItem.h"
#include "com/igormaznitsa/prol/containers/KnowledgeBaseInsideClauseList.h"
#include "com/igormaznitsa/prol/containers/MemoryFactIterator.h"
#include "com/igormaznitsa/prol/data/Term.h"
#include "com/igormaznitsa/prol/data/TermStruct.h"
#include "java/util/NoSuchElementException.h"

@implementation ComIgormaznitsaProlContainersMemoryFactIterator

- (id)initWithComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList:(ComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList *)list
                                   withComIgormaznitsaProlDataTermStruct:(ComIgormaznitsaProlDataTermStruct *)template_ {
  return [super initWithComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList:list withComIgormaznitsaProlDataTermStruct:template_];
}

- (ComIgormaznitsaProlContainersInsideClauseListItem *)findFirstElement {
  ComIgormaznitsaProlContainersInsideClauseListItem *firstitem = nil;
  while (YES) {
    firstitem = [((ComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList *) nil_chk(predicateList_)) findDirectWithComIgormaznitsaProlDataTermStruct:template__ withComIgormaznitsaProlContainersInsideClauseListItem:firstitem];
    if (firstitem == nil || [firstitem isFact]) {
      break;
    }
  }
  return firstitem;
}

- (ComIgormaznitsaProlDataTermStruct *)next {
  if (lastFound_ == nil) {
    @throw [[JavaUtilNoSuchElementException alloc] init];
  }
  ComIgormaznitsaProlDataTermStruct *result = (ComIgormaznitsaProlDataTermStruct *) check_class_cast([((ComIgormaznitsaProlDataTermStruct *) nil_chk([((ComIgormaznitsaProlContainersInsideClauseListItem *) nil_chk(lastFound_)) getClause])) makeClone], [ComIgormaznitsaProlDataTermStruct class]);
  while (YES) {
    lastFound_ = [((ComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList *) nil_chk(predicateList_)) findDirectWithComIgormaznitsaProlDataTermStruct:template__ withComIgormaznitsaProlContainersInsideClauseListItem:lastFound_];
    if (lastFound_ == nil || [lastFound_ isFact]) {
      break;
    }
  }
  return result;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithComIgormaznitsaProlContainersKnowledgeBaseInsideClauseList:withComIgormaznitsaProlDataTermStruct:", "MemoryFactIterator", NULL, 0x1, NULL },
    { "findFirstElement", NULL, "Lcom.igormaznitsa.prol.containers.InsideClauseListItem;", 0x4, NULL },
    { "next", NULL, "Lcom.igormaznitsa.prol.data.TermStruct;", 0x1, NULL },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlContainersMemoryFactIterator = { "MemoryFactIterator", "com.igormaznitsa.prol.containers", NULL, 0x10, 3, methods, 0, NULL, 0, NULL};
  return &_ComIgormaznitsaProlContainersMemoryFactIterator;
}

@end
