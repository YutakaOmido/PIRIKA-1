//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: com/igormaznitsa/prol/trace/TraceListener.java
//
//  Created by katsura on 14/04/13.
//

#include "com/igormaznitsa/prol/logic/Goal.h"
#include "com/igormaznitsa/prol/trace/TraceListener.h"


@interface ComIgormaznitsaProlTraceTraceListener : NSObject
@end

@implementation ComIgormaznitsaProlTraceTraceListener

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "onProlGoalCallWithComIgormaznitsaProlLogicGoal:", "onProlGoalCall", "Z", 0x401, NULL },
    { "onProlGoalRedoWithComIgormaznitsaProlLogicGoal:", "onProlGoalRedo", "Z", 0x401, NULL },
    { "onProlGoalFailWithComIgormaznitsaProlLogicGoal:", "onProlGoalFail", "V", 0x401, NULL },
    { "onProlGoalExitWithComIgormaznitsaProlLogicGoal:", "onProlGoalExit", "V", 0x401, NULL },
  };
  static J2ObjcClassInfo _ComIgormaznitsaProlTraceTraceListener = { "TraceListener", "com.igormaznitsa.prol.trace", NULL, 0x201, 4, methods, 0, NULL, 0, NULL};
  return &_ComIgormaznitsaProlTraceTraceListener;
}

@end
