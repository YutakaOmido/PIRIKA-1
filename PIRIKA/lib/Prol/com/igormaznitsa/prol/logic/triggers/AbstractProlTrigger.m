//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/logic/triggers/AbstractProlTrigger.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/logic/ProlContext.h"
#include "com/igormaznitsa/prol/logic/triggers/AbstractProlTrigger.h"
#include "com/igormaznitsa/prol/logic/triggers/ProlTriggerType.h"
#include "com/igormaznitsa/prol/logic/triggers/TriggerEvent.h"
#include "com/igormaznitsa/prol/utils/Utils.h"
#include "java/lang/IllegalArgumentException.h"
#include "java/lang/NullPointerException.h"
#include "java/util/Collections.h"
#include "java/util/HashMap.h"
#include "java/util/Map.h"

@implementation ComIgormaznitsaProlLogicTriggersAbstractProlTrigger

- (id)init {
  if (self = [super init]) {
    signatureMap_ = [JavaUtilCollections synchronizedMapWithJavaUtilMap:[[JavaUtilHashMap alloc] init]];
  }
  return self;
}

- (ComIgormaznitsaProlLogicTriggersAbstractProlTrigger *)addSignatureWithNSString:(NSString *)signature
                          withComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum:(ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum *)observedEvent {
  if (signature == nil || observedEvent == nil) {
    @throw [[JavaLangNullPointerException alloc] initWithNSString:@"Both arguments must not be null"];
  }
  NSString *processedsignature = [ComIgormaznitsaProlUtilsUtils validateSignatureWithNSString:signature];
  if (processedsignature == nil) {
    @throw [[JavaLangIllegalArgumentException alloc] initWithNSString:[NSString stringWithFormat:@"Wrong signature format [%@]", signature]];
  }
  else {
    processedsignature = [ComIgormaznitsaProlUtilsUtils normalizeSignatureWithNSString:processedsignature];
  }
  (void) [((id<JavaUtilMap>) nil_chk(signatureMap_)) putWithId:processedsignature withId:observedEvent];
  return self;
}

- (ComIgormaznitsaProlLogicTriggersAbstractProlTrigger *)removeSignatureWithNSString:(NSString *)signature {
  if (signature == nil) {
    @throw [[JavaLangNullPointerException alloc] initWithNSString:@"Signature is null"];
  }
  NSString *processedsignature = [ComIgormaznitsaProlUtilsUtils validateSignatureWithNSString:signature];
  if (processedsignature == nil) {
    @throw [[JavaLangIllegalArgumentException alloc] initWithNSString:[NSString stringWithFormat:@"Wrong signature format [%@]", signature]];
  }
  else {
    processedsignature = [ComIgormaznitsaProlUtilsUtils normalizeSignatureWithNSString:processedsignature];
  }
  (void) [((id<JavaUtilMap>) nil_chk(signatureMap_)) removeWithId:processedsignature];
  return self;
}

- (id<JavaUtilMap>)getSignatures {
  return signatureMap_;
}

- (void)onContextHaltingWithComIgormaznitsaProlLogicProlContext:(ComIgormaznitsaProlLogicProlContext *)param0 {
  // can't call an abstract method
  [self doesNotRecognizeSelector:_cmd];
}

- (void)onTriggerEventWithComIgormaznitsaProlLogicTriggersTriggerEvent:(ComIgormaznitsaProlLogicTriggersTriggerEvent *)param0 {
  // can't call an abstract method
  [self doesNotRecognizeSelector:_cmd];
}

- (void)copyAllFieldsTo:(ComIgormaznitsaProlLogicTriggersAbstractProlTrigger *)other {
  [super copyAllFieldsTo:other];
  other->signatureMap_ = signatureMap_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "init", "AbstractProlTrigger", NULL, 0x1, NULL },
    { "addSignatureWithNSString:withComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum:", "addSignature", "Lcom.igormaznitsa.prol.logic.triggers.AbstractProlTrigger;", 0x1, NULL },
    { "removeSignatureWithNSString:", "removeSignature", "Lcom.igormaznitsa.prol.logic.triggers.AbstractProlTrigger;", 0x1, NULL },
    { "getSignatures", NULL, "Ljava.util.Map;", 0x1, NULL },
    { "onContextHaltingWithComIgormaznitsaProlLogicProlContext:", "onContextHalting", "V", 0x401, NULL },
    { "onTriggerEventWithComIgormaznitsaProlLogicTriggersTriggerEvent:", "onTriggerEvent", "V", 0x401, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "signatureMap_", NULL, 0x14, "Ljava.util.Map;" },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlLogicTriggersAbstractProlTrigger = { "AbstractProlTrigger", "com.igormaznitsa.prol.logic.triggers", NULL, 0x401, 6, methods, 1, fields, 0, NULL};
  return &_ComIgormaznitsaProlLogicTriggersAbstractProlTrigger;
}

@end