package com.katsura.iProlog;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.util.Iterator;
import java.util.Map;

import com.igormaznitsa.prol.data.Term;
import com.igormaznitsa.prol.data.Var;
import com.igormaznitsa.prol.io.ProlStreamManager;
import com.igormaznitsa.prol.logic.Goal;
import com.igormaznitsa.prol.logic.ProlContext;
import com.igormaznitsa.prol.parser.ProlConsult;
import com.igormaznitsa.prol.utils.Utils;
import com.igormaznitsa.prol.exceptions.ParserException;

/**
 * Copyright 2014 Yuki Katsura (kryotos.nv@gmail.com).
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
public class PrologInterface {
	private ProlContext context = null;
	private String name = null;
	private Goal goal = null;
	
	/**
	 * A constructor allows without name.
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public PrologInterface() throws IOException, InterruptedException{
		this("test");
	}
	
	/**
	 * A constructor sets name.
	 * @param name
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public PrologInterface(String name) throws IOException, InterruptedException{
		this.context = new ProlContext(name);
	}
	
	/**
	 * Halt the context and release the resource. Renew the engine.
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public void clearEngine() throws IOException, InterruptedException{
		this.context.halt();
		this.context = new ProlContext(name);
	}
	
	/**
	 * Input from existing file.
	 * @param fileName
	 * @return
	 */
	public String fileInput(String fileName){
		ProlStreamManager streamManager = this.context.getStreamManager();
		Reader reader = null;
		try {
			reader = streamManager.getReaderForResource(fileName);
			final ProlConsult consulter = new ProlConsult(reader, context);
		    consulter.consult();
		} catch (IOException e) {
			return new String("File not found\n");
		} finally {
			if (reader!=null) {
				try {
					reader.close();
				} catch (IOException e) {e.printStackTrace();}
			}
		}
        
		return new String("Complete\n");
	}
	
	/**
	 * Input from user.
	 * @param fileName
	 * @return
	 */
	public Term userInput(String input){
		try {
			this.goal = null;
			this.goal = new Goal(input, this.context);
	        return this.goal.solve();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Get next answer.
	 * @return
	 */
	public Term fail(){
        if(this.goal==null){return null;}
		try {
			return this.goal.solve();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Term converted to String.
	 * @param term
	 * @return
	 */
	public String resultTerm2string(Term term){
		StringBuffer sb = new StringBuffer();
	    final Map<String, Var> vars = Utils.fillTableWithVars(term);
	    final Iterator<Var> iter = vars.values().iterator();
	    while (iter.hasNext()) {
	    	final Var variable = iter.next();
	    	if (variable.isAnonymous()) {
	    		continue;
	    	}
	    	sb.append(variable.getText());
	    	sb.append("=");
	    	if (variable.isUndefined()) {
	    		sb.append("???");
                sb.append("\n");
	    	}else {
	    		sb.append(variable.toString());
	    		sb.append("\n");
	    	}
	    }
	    return sb.toString();
	}
    
	/**
	 * To out all dynamic value of the knowledge into writer in the prolog source format.
	 */
	public String listing(){
		final ByteArrayOutputStream baos = new ByteArrayOutputStream(1024);
		final PrintWriter out = new PrintWriter(baos);
        
		this.context.getKnowledgeBase().write(out);
		try {
			baos.close();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserException e){
            e.getMessage();
            
        }
		out.flush();
		out.close();
		return new String(baos.toByteArray());
	}
	
	/*
     public static void main(String args[]){
     try {
     PrologCore c = new PrologCore();
     c.fileInput("/Users/katsura/Documents/workspace/test/test1.pl");
     Term t = c.userInput("child_of(X,Y).");
     System.out.println(c.resultTerm2string(t));
     } catch (IOException e) {
     e.printStackTrace();
     } catch (InterruptedException e) {
     e.printStackTrace();
     }
     
     }*/
}
