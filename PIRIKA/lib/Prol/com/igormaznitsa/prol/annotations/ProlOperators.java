/*
 * Copyright 2014 Igor Maznitsa (http://www.igormaznitsa.com).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.igormaznitsa.prol.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.igormaznitsa.prol.data.Operator;

/**
 * The annotation allows to define a few operators
 *
 * @author Igor Maznitsa (igor.maznitsa@igormaznitsa.com)
 */
//@Target(value = ElementType.TYPE)
//@Retention(value = RetentionPolicy.RUNTIME)
public class ProlOperators {
    
    /**
     * Array of ProlOperator annotations
     *
     * @return an array of ProlOperator annotations
     * @see com.igormaznitsa.prol.annotations.ProlOperator
     */
    public static ProlOperator[] Operators = {
    //------------------------
    new ProlOperator(0, Operator.OPTYPE_XFX, "("),
    new ProlOperator(0, Operator.OPTYPE_XFX, ")"),
    new ProlOperator(0, Operator.OPTYPE_XFX, "["),
    new ProlOperator(0, Operator.OPTYPE_XFX, "]"),
    new ProlOperator(1200, Operator.OPTYPE_XF, "."),
    new ProlOperator(1200, Operator.OPTYPE_XFX, "|"),
    //------------------------
    new ProlOperator(700, Operator.OPTYPE_XFX, "is"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "\\="),
    new ProlOperator(1000, Operator.OPTYPE_XFY, ","),
    new ProlOperator(1050, Operator.OPTYPE_XFY, "->"),
    new ProlOperator(1100, Operator.OPTYPE_XFY, ";"),
    new ProlOperator(1200, Operator.OPTYPE_FX, "?-"),
    new ProlOperator(1200, Operator.OPTYPE_FX, ":-"),
    new ProlOperator(1200, Operator.OPTYPE_XFX, ":-"),
    new ProlOperator(900, Operator.OPTYPE_FY, "\\+"),
    new ProlOperator(700, Operator.OPTYPE_XFX, ">"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "<"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "=<"),
    new ProlOperator(700, Operator.OPTYPE_XFX, ">="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "=="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "=\\="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "\\=="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "@<"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "@>"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "@=<"),
    new ProlOperator(700, Operator.OPTYPE_XFX, "@>="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "=:="),
    new ProlOperator(700, Operator.OPTYPE_XFX, "=.."),
    new ProlOperator(500, Operator.OPTYPE_YFX, "/\\"),
    new ProlOperator(500, Operator.OPTYPE_YFX, "\\/"),
    new ProlOperator(500, Operator.OPTYPE_YFX, "+"),
    new ProlOperator(500, Operator.OPTYPE_YFX, "-"),
    new ProlOperator(500, Operator.OPTYPE_FX, "not"),
    new ProlOperator(500, Operator.OPTYPE_FX, "+"),
    new ProlOperator(500, Operator.OPTYPE_FX, "-"),
    new ProlOperator(400, Operator.OPTYPE_YFX, "*"),
    new ProlOperator(400, Operator.OPTYPE_YFX, "/"),
    new ProlOperator(400, Operator.OPTYPE_YFX, "//"),
    new ProlOperator(400, Operator.OPTYPE_YFX, "rem"),
    new ProlOperator(400, Operator.OPTYPE_YFX, "<<"),
    new ProlOperator(400, Operator.OPTYPE_YFX, ">>"),
    new ProlOperator(300, Operator.OPTYPE_XFX, "mod"),
    new ProlOperator(200, Operator.OPTYPE_FY, "\\"),
    new ProlOperator(200, Operator.OPTYPE_XFX, "**"),
    new ProlOperator(200, Operator.OPTYPE_XFY, "^")};
}
