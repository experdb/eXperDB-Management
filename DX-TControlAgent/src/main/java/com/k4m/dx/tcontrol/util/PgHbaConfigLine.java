package com.k4m.dx.tcontrol.util;

import java.util.StringTokenizer;

public class PgHbaConfigLine {
	
	public final static int PGC_LOCAL 	= 0;
	public final static int PGC_HOST 	= 1;
	public final static int PGC_HOSTSSL	= 2;
	public final static int PGC_HOSTNOSSL=3;
	public final static int PGC_INVALIDCONF=4;
		
	public final static int	PGC_TRUST		  =0 ;
	public final static int	PGC_REJECT        =1 ;
	public final static int	PGC_MD5           =2 ;
	public final static int	PGC_CRYPT         =3 ;
	public final static int	PGC_PASSWORD      =4 ;
	public final static int	PGC_KRB4          =5 ;
	public final static int	PGC_KRB5          =6 ;
	public final static int	PGC_IDENT         =7 ;
	public final static int	PGC_PAM           =8 ;
	public final static int	PGC_LDAP          =9 ;
	public final static int	PGC_GSS           =10;
	public final static int	PGC_SSPI          =11;
	public final static int	PGC_CERT          =12;
	public final static int	PGC_PEER          =13;
	public final static int	PGC_RADIUS        =14;
	public final static int	PGC_INVALIDMETHOD =15;

	private String text;
	private String database;
	private String user;
	private String ipaddress;
	private String option;
	private int connectType;
	private int method;
	private int itemNumber;

	private boolean isValid;
	private boolean isComment;
	private boolean changed;
	
	static String [] pgHbaConnectTypeStrings = {"local","host","hostssl","hostnossl"};
	static String [] pgHbaMethodStrings ={"trust","reject","md5","crypt","password","krb4","krb5","ident","pam","ldap","gss","sspi","cert","peer","radius"};

		public PgHbaConfigLine(String line)
		{
			if(line != null){
				setItemNumber(-1);
				setValid(false);
				isComment = true;
				connectType = PGC_INVALIDCONF;
				method = PGC_INVALIDMETHOD;
	
				Init(line);
			}
		}


		public void Init(String line)
		{
			setValid(false);
			connectType = PGC_INVALIDCONF;
			changed = false;
			String strTemp = "";

			if (line.isEmpty()){
				text = "";
				return;
			}

			text = line;

			StringTokenizer st = new StringTokenizer(line," |\t");
			
		    if(!st.hasMoreTokens())
		    	return;
		    
	    	strTemp = st.nextToken();
	    	if(strTemp.contains("#")){
	    		strTemp = strTemp.replaceFirst("#","");
	    		isComment = true;
	    	}
	    	else
	    		isComment = false;		    	
		    
		    for(int i = 0; i < pgHbaConnectTypeStrings.length; i++){
		    	if((strTemp.length() > 0) && (pgHbaConnectTypeStrings[i].endsWith(strTemp))){
		    		connectType = i; break;
		    	}		    		
		    }
		    if(connectType == PGC_INVALIDCONF)
		    	return;
		    
//2		    	
		    if(!st.hasMoreTokens())
		    	return;
		    
		    database = st.nextToken();
//3
		    if(!st.hasMoreTokens())
		    	return;
		    
		    user = st.nextToken();
//4
		    
		    if (connectType == PGC_LOCAL)
			{
				// no ip address
			}
			else
			{
			    if(!st.hasMoreTokens())
			    	return;
			    
			    ipaddress = st.nextToken();
			    if(!ipaddress.contains("/")){
			    	ipaddress += "/32";
			    }
			}
//5		    
		    if(!st.hasMoreTokens())
		    	return;
		    
	    	strTemp = st.nextToken();
	    	
		    for(int i = 0; i < pgHbaMethodStrings.length; i++){
		    	if(pgHbaMethodStrings[i].endsWith(strTemp)){
		    		method = i; break;
		    	}		    		
		    }
		    
//6
		    if(st.hasMoreTokens()){
			    option = st.nextToken();
		    }		    

			setValid(true);
		}

//		const wxChar *pgHbaConfigLine::GetConnectType()
		public String getConnectType()
		{
			if (connectType >= 0 && connectType < PGC_INVALIDCONF)
				return pgHbaConnectTypeStrings[connectType];
			return null;
		}

		public void setConnectType(String connType)
		{
		    for(int i = 0; i < pgHbaConnectTypeStrings.length; i++){
		    	if((connType.length() > 0) && (pgHbaConnectTypeStrings[i].endsWith(connType))){
		    		connectType = i; break;
		    	}		    		
		    }
		}

//		const wxChar *pgHbaConfigLine::GetMethod()
		public String getMethod()
		{
			if (method >= 0 && method < PGC_INVALIDMETHOD)
				return pgHbaMethodStrings[method];
			return null;
		}

		public void setMethod(String method)
		{
		    for(int i = 0; i < pgHbaMethodStrings.length; i++){
		    	if(pgHbaMethodStrings[i].endsWith(method)){
		    		this.method = i; break;
		    	}		    		
		    }
		}

		public String getText()
		{
			if (!changed)
				return text;

			String str = "";
			String tabspace = "\t ";
			if (isComment)
				str = "#";

			str += getConnectType()
			       +  tabspace + database
			       +  tabspace + user;

			if (connectType != PGC_LOCAL)
				str += tabspace + ipaddress;

			str += tabspace + getMethod();

			
			if (method >= PGC_IDENT && !option.isEmpty())
				str += tabspace + option;

			return str;
		}

		public boolean isValid() {
			return isValid;
		}
		
		public boolean isComment() {
			return isComment;
		}

		public void setComment(boolean isComment) {
			this.isComment = isComment;
		}

		public void setValid(boolean isValid) {
			this.isValid = isValid;
		}

		public int getItemNumber() {
			return itemNumber;
		}

		public void setItemNumber(int itemNumber) {
			this.itemNumber = itemNumber;
		}
		
		public String getDatabase () {
			return database;
		}

		public void setDatabase (String database) {
			this.database = database;
		}
		
		public String getUser () {
			return user;
		}
		
		public void setUser (String user) {
			this.user = user;
		}

		public String getIpaddress() {
			return ipaddress;
		}

		public void setIpaddress(String ipaddress) {
			this.ipaddress = ipaddress;
		}

		public String getOption() {
			return option;
		}

		public void setOption(String option) {
			this.option = option;
		}
		
		public boolean getChanged() {
			return changed;
		}
		
		public void setChanged(boolean changed) {
			this.changed = changed;
		}
}
