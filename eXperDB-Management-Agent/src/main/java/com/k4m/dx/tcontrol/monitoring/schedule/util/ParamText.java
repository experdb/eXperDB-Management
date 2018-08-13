
package com.k4m.dx.tcontrol.monitoring.schedule.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref.STRING;



public class ParamText {

	private String startBrace;
	private String endBrace;

	private List<Object> tokenList = new ArrayList<Object>();
	private List<String> keyList = new ArrayList<String>();

	public ParamText(String plainText) {
		this(plainText, "${", "}");
	}

	public ParamText(String plainText, String startBrace, String endBrace) {
		this.startBrace = startBrace;
		this.endBrace = endBrace;

		while (plainText.length() > 0) {
			int pos = plainText.indexOf(startBrace);
			if (pos < 0) {
				this.tokenList.add(plainText);
				return;// end
			} else if (pos > 0) {
				this.tokenList.add(plainText.substring(0, pos));
				plainText = plainText.substring(pos);
			} else {
				pos += startBrace.length();
				int nextPos = plainText.indexOf(endBrace, pos);
				if (nextPos < 0)
					break;
				String argName = plainText.substring(pos, nextPos).trim();
				this.keyList.add(argName);
				this.tokenList.add(new STRING(argName));
				plainText = plainText.substring(nextPos + endBrace.length());
			}
		}
	}

	public String getText(Object[] args) {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0, idx = 0; i < tokenList.size(); i++) {
			Object o = tokenList.get(i);
			if (o instanceof STRING) {
				if (idx < args.length)
					buffer.append(args[idx++]);
				else
					buffer.append(o);
			} else {
				buffer.append(o);
			}
		}
		return buffer.toString();
	}

	public String getText(Object arg) {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < tokenList.size(); i++) {
			Object o = tokenList.get(i);
			if (o instanceof STRING) {
				buffer.append(arg);
			} else {
				buffer.append(o);
			}
		}
		return buffer.toString();
	}

	public String getText(Map<String, ?> argm) {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < tokenList.size(); i++) {
			Object o = tokenList.get(i);
			if (o instanceof STRING) {
				STRING p = (STRING) o;
				if (argm.containsKey(p.value)) {
					buffer.append(argm.get(p.value));
				} else {
					buffer.append(o);
				}
			} else {
				buffer.append(o);
			}
		}
		return buffer.toString();
	}

	public List<String> getKeyList() {
		return keyList;
	}

	public String toString() {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < tokenList.size(); i++) {
			Object o = tokenList.get(i);
			if (o instanceof STRING) {
				buffer.append(this.startBrace).append(o).append(this.endBrace);
			} else {
				buffer.append(o);
			}
		}
		return buffer.toString();
	}

}