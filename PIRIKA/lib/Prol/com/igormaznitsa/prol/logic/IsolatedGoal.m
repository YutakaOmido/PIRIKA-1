//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/logic/IsolatedGoal.java
//
//  Created by katsura on 14/04/13.
//

#include "IOSClass.h"
#include "com/igormaznitsa/prol/data/Term.h"
#include "com/igormaznitsa/prol/data/Var.h"
#include "com/igormaznitsa/prol/logic/Goal.h"
#include "com/igormaznitsa/prol/logic/IsolatedGoal.h"
#include "com/igormaznitsa/prol/logic/ProlContext.h"
#include "java/lang/InterruptedException.h"
#include "java/lang/NullPointerException.h"
#include "java/lang/UnsupportedOperationException.h"
#include "java/util/List.h"

@implementation ComIgormaznitsaProlLogicIsolatedGoal

- (id)getAuxObject {
  return [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getAuxObject];
}

- (id)initWithComIgormaznitsaProlLogicGoal:(ComIgormaznitsaProlLogicGoal *)goal {
  if (self = [super init]) {
    if (goal == nil) {
      @throw [[JavaLangNullPointerException alloc] initWithNSString:@"A Base goal must not be null"];
    }
    basegoal_ = goal;
  }
  return self;
}

- (void)cut {
  @throw [[JavaLangUnsupportedOperationException alloc] initWithNSString:@"Unsupported operation"];
}

- (void)cutLocal {
  @throw [[JavaLangUnsupportedOperationException alloc] initWithNSString:@"Unsupported operation"];
}

- (id<JavaUtilList>)getChainAsList {
  return [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getChainAsList];
}

- (ComIgormaznitsaProlLogicProlContext *)getContext {
  return [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getContext];
}

- (NSString *)getVarAsTextWithNSString:(NSString *)varName {
  return [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getVarAsTextWithNSString:varName];
}

- (BOOL)isCompleted {
  return [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) isCompleted];
}

- (void)noMoreVariants {
  @throw [[JavaLangUnsupportedOperationException alloc] initWithNSString:@"Unsupported operation"];
}

- (ComIgormaznitsaProlLogicGoal *)replaceLastGoalAtChainWithComIgormaznitsaProlDataTerm:(ComIgormaznitsaProlDataTerm *)goal {
  @throw [[JavaLangUnsupportedOperationException alloc] initWithNSString:@"Unsupported operation"];
}

- (ComIgormaznitsaProlDataTerm *)getGoalTerm {
  return [((ComIgormaznitsaProlDataTerm *) nil_chk([((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getGoalTerm])) makeClone];
}

- (void)setAuxObjectWithId:(id)obj {
  @throw [[JavaLangUnsupportedOperationException alloc] initWithNSString:@"Unsupported operation"];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"{isolated}%@", [super description]];
}

- (ComIgormaznitsaProlDataTerm *)solve {
  ComIgormaznitsaProlDataTerm *result = [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) solve];
  return result == nil ? nil : [result makeClone];
}

- (ComIgormaznitsaProlDataVar *)getVarForNameWithNSString:(NSString *)name {
  ComIgormaznitsaProlDataVar *var = [((ComIgormaznitsaProlLogicGoal *) nil_chk(basegoal_)) getVarForNameWithNSString:name];
  return var == nil ? nil : (ComIgormaznitsaProlDataVar *) check_class_cast([var makeClone], [ComIgormaznitsaProlDataVar class]);
}

- (void)copyAllFieldsTo:(ComIgormaznitsaProlLogicIsolatedGoal *)other {
  [super copyAllFieldsTo:other];
  other->basegoal_ = basegoal_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "getAuxObject", NULL, "Ljava.lang.Object;", 0x1, NULL },
    { "initWithComIgormaznitsaProlLogicGoal:", "IsolatedGoal", NULL, 0x1, NULL },
    { "cut", NULL, "V", 0x1, NULL },
    { "cutLocal", NULL, "V", 0x1, NULL },
    { "getChainAsList", NULL, "Ljava.util.List;", 0x1, NULL },
    { "getContext", NULL, "Lcom.igormaznitsa.prol.logic.ProlContext;", 0x1, NULL },
    { "getVarAsTextWithNSString:", "getVarAsText", "Ljava.lang.String;", 0x1, NULL },
    { "isCompleted", NULL, "Z", 0x1, NULL },
    { "noMoreVariants", NULL, "V", 0x1, NULL },
    { "replaceLastGoalAtChainWithComIgormaznitsaProlDataTerm:", "replaceLastGoalAtChain", "Lcom.igormaznitsa.prol.logic.Goal;", 0x1, NULL },
    { "getGoalTerm", NULL, "Lcom.igormaznitsa.prol.data.Term;", 0x1, NULL },
    { "setAuxObjectWithId:", "setAuxObject", "V", 0x1, NULL },
    { "description", "toString", "Ljava.lang.String;", 0x1, NULL },
    { "solve", NULL, "Lcom.igormaznitsa.prol.data.Term;", 0x1, "Ljava.lang.InterruptedException;" },
    { "getVarForNameWithNSString:", "getVarForName", "Lcom.igormaznitsa.prol.data.Var;", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "basegoal_", NULL, 0x12, "Lcom.igormaznitsa.prol.logic.Goal;" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlLogicIsolatedGoal = { "IsolatedGoal", "com.igormaznitsa.prol.logic", NULL, 0x1, 15, methods, 1, fields, 0, NULL};
  return &_ComIgormaznitsaProlLogicIsolatedGoal;
}

@end