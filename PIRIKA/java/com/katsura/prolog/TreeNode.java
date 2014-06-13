package com.katsura.prolog;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * The class which forms the argument tree.
 * <br>
 * @author katsura
 *
 */
public class TreeNode{

//	private TreeNode prev=null;
	private TreeNode[] next=null;
	private String arg=null;
	private String name=null;
	private int depth;
	
	private int width=0;

	/**
	 * initialize.
	 * @param prev - previous argument pointer.
	 * @param name - user name
	 * @param depth - tree depth
	 * @param arg - argument(demonstration).
	 */
	public TreeNode(TreeNode prev,String name,int depth,String arg){
//		this.prev = prev;
		this.name = name;
		this.depth = depth;
		this.arg = arg;
		this.next = null;
	}

	/**
	 * get this node argument.
	 */
	public String getArgument(){
		return this.arg;
	}

	public int getNodeWidth(){
		return width;
	}
	
	public int getMaxDepth(){
		if (next==null) {
			return depth+1;
		}else{
			int max=0;
			for (int i = 0; i < next.length; i++) {
				TreeNode t = next[i];
				int j = t.getMaxDepth();
				if (max<j) {
					max = j;
				}
			}
			
			return max;
		}
	}

	/**
	 * 論証木を構成する.
	 * <p>
	 * ポインタを用いて議論木を表現する.<br>
	 * 深さ優先で構成し,論証がなくなったら別の同じ深さの論証に処理を移す.
	 * </p>
	 * @param proList - 論証の配列.(重複の確認)
	 * @param ProlMain[].
	 */
	public int nextArgument(List<String> argList, ProlMain[] prolList){
		/**
		 * String - demonstration.</br>
		 * String - userName.
		 */
		Map<String,String> result = new HashMap<String,String>();
		for (int i = 0; i < prolList.length; i++) {
			ProlMain prolMain = prolList[i];

			String s = prolMain.defeat(this.arg);
			if(s.equals("[]")){ continue; }
			String userName = prolMain.getName();
			String str = s.substring(2, s.length()-2);
			String[] defeateList = str.split("\\],\\[", 0);
			for(int j=0;j<defeateList.length;j++){
				String string = new String("["+ defeateList[j] + "]");
				if(!result.containsKey(string)){
					if (argList.contains(string)) {
						// if this node is proponent.
						if (depth%2==0) {
							int count=0;
							for (int k = 0; k < argList.size(); k++) {
								if (argList.get(k).equals(string)) {
									count++;
									if (count>1) {break;}
								}
							}
							if (count>1) {continue;}
						}else{continue;}
					}
					result.put(string,userName);
				}
			}
		}
		if(result.isEmpty()){
			width = 1;
			return width;
		}else{
			next = new TreeNode[result.size()];
		}

		Iterator<String> pro = result.keySet().iterator();
		for(int i=0;pro.hasNext();i++) {
			String arg = pro.next();
			List<String> argList2 = new LinkedList<String>(argList);
			argList2.add(arg);
			next[i] = new TreeNode(this, result.get(arg), depth+1, arg);
			width = width + next[i].nextArgument(argList2,prolList);
		}
		
		return width;
	}

	/**
	 *	配列に結果を保存する.
	 */
	public List<String> insertArgument(List<String> argTree){
		argTree.add(String.valueOf(depth));
		argTree.add(arg);
		for(int i=0;i<this.next.length;i++){
			if(this.next[i]!=null){
				this.next[i].insertArgument(argTree);
			}
		}
		return argTree;
	}

	/**
	 *	配列に結果を保存する.
	 */
	public List<String> insertArgumentWithName(List<String> argTree){
		argTree.add(String.valueOf(this.depth));
		argTree.add(this.name);
		argTree.add(this.arg);
		if(this.next!=null){
			for(int i=0;i<this.next.length;i++){
				if(this.next[i]!=null){
					this.next[i].insertArgumentWithName(argTree);
				}
			}
		}
		return argTree;
	}
}
