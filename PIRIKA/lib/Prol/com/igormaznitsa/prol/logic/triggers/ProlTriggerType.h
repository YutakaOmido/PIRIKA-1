//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/logic/triggers/ProlTriggerType.java
//
//  Created by katsura on 14/04/13.
//

#ifndef _ComIgormaznitsaProlLogicTriggersProlTriggerType_H_
#define _ComIgormaznitsaProlLogicTriggersProlTriggerType_H_

#import "JreEmulation.h"
#include "java/lang/Enum.h"

typedef enum {
  ComIgormaznitsaProlLogicTriggersProlTriggerType_TRIGGER_ASSERT = 0,
  ComIgormaznitsaProlLogicTriggersProlTriggerType_TRIGGER_RETRACT = 1,
  ComIgormaznitsaProlLogicTriggersProlTriggerType_TRIGGER_ASSERT_RETRACT = 2,
} ComIgormaznitsaProlLogicTriggersProlTriggerType;

@interface ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum : JavaLangEnum < NSCopying > {
}
+ (ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum *)TRIGGER_ASSERT;
+ (ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum *)TRIGGER_RETRACT;
+ (ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum *)TRIGGER_ASSERT_RETRACT;
+ (IOSObjectArray *)values;
+ (ComIgormaznitsaProlLogicTriggersProlTriggerTypeEnum *)valueOfWithNSString:(NSString *)name;
- (id)copyWithZone:(NSZone *)zone;
- (id)initWithNSString:(NSString *)__name withInt:(int)__ordinal;
@end

#endif // _ComIgormaznitsaProlLogicTriggersProlTriggerType_H_