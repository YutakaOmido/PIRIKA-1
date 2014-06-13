package com.katsura.prolog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.igormaznitsa.prol.exceptions.ParserException;
import com.igormaznitsa.prol.exceptions.ProlCriticalError;
import com.igormaznitsa.prol.exceptions.ProlInstantiationErrorException;

public class JavaArgumentTree{
	protected ProlMain[] prol;
	protected TreeNode[] tree;

	/**
	 * initialize.
	 * @param truthvalue - String
	 * @param userMap - Map<'String','String'> - userName and ealp file path
	 * @return
	 */
	public void init(String LMAPath, String truthvaluePath, Map<String, String>userMap){
		this.prol = new ProlMain[userMap.size()];

		Iterator<String> it = userMap.keySet().iterator();
		for(int i=0;it.hasNext();) {
			String userName = it.next();
			String filepath = userMap.get(userName);
			this.prol[i] = new ProlMain(userName);
			if(this.prol[i].init(LMAPath, truthvaluePath, filepath)){
				i++;
			}
		}
	}
	
	/**
	 * The argument tree is calculated.
	 * @param subject
	 * @return List<'String'> - depth,userName,argument
	 */
	public List<String> calculate(String subject) throws ProlCriticalError,ParserException,ProlInstantiationErrorException{
		Map<String,String> demo = new HashMap<String,String>();
		
		for (int i = 0; i < prol.length; i++) {
            ProlMain prolMain = this.prol[i];
			String demoString = prolMain.getArgument(subject);
			if (demoString.equals("[]")) { continue;}
				
			String s = demoString.substring(2, demoString.length()-2);
			String[] demoList = s.split("\\],\\[", 0);
			for(int k=0;k<demoList.length;k++){
				String str = new String('[' + demoList[k] + ']');

				if(!demo.containsKey(str)){
					demo.put(str,prolMain.getName());
				}
			}
        }
		
        tree = new TreeNode[demo.size()];
        Iterator<String> it = demo.keySet().iterator();
        for(int i=0;it.hasNext();i++) {
        	List<String> proList = new LinkedList<String>();
        	String demoString = it.next();
        	String userName = demo.get(demoString);
        	tree[i] = new TreeNode(null, userName, 0 ,demoString);
        	proList.add(demoString);
        	tree[i].nextArgument(proList, this.prol);
        }
        
        List<String> resultList = new ArrayList<String>();
        for(int i=0;i<tree.length;i++){
        	tree[i].insertArgumentWithName(resultList);
        }
        
        return resultList;
	}
}
