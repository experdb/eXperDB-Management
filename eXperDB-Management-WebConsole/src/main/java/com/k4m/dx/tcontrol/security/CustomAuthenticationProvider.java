package com.k4m.dx.tcontrol.security;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Service;


@Service
public class CustomAuthenticationProvider implements AuthenticationProvider {  
	
	
	/**
	 * Logger 설정 
	 */
	private static final Logger logger = LoggerFactory.getLogger(CustomAuthenticationProvider.class);
	
	 
	private SqlSession sqlSession;
	
    public void setSqlSession(SqlSession sqlsession) {
		this.sqlSession = sqlsession;
	}

	@Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		
		// Password 체크 로직이 필요함 
		String user_id = (String)authentication.getPrincipal();		
		String user_pw = (String)authentication.getCredentials();
		String reqip = "0.0.0.0";
		// Request 방식으로 가져오기 Web.xml 에 Listner org.springframework.web.context.request.RequestContextListener 가 있어야 사용가능함 
//		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest(); 
//        logger.info("Local IP : " + request.getRemoteAddr());
		// Security 자체 방식 사용 
		
		Object details = authentication.getDetails();
		if (details instanceof WebAuthenticationDetails) {
			reqip = ((WebAuthenticationDetails)details).getRemoteAddress();  
		}
		
			
		
				
		// check whether user's credentials are valid.
		// if false, throw new BadCredentialsException(messages.getMessage("AbstractUserDetailsAuthenticationProvider.badCredentials", "Bad credentials"));
		
		try{
			
			System.out.println("========로그인부분==========");
/*			HashMap<String, String> paramval = new HashMap<String, String>();
			paramval.put("user_id", user_id);
//			paramval.put("user_pw", user_pw);
			
			//SHA256 sha = new SHA256();
			
			String crypted_pw = sha.SHA256(user_pw);
			
			
			List<Map<String, String>> rtnvalue = sqlSession.selectList("cert_0001.getLoginInfo" ,  paramval);
			
			int intLoginCnt = rtnvalue.size();
			
			if(intLoginCnt == 0) {
				throw new BadCredentialsException("등록되지 않은 사용자 입니다. 관리자에게 문의 하여주십시오.");
			}
			
			String saved_pw = rtnvalue.get(0).get("user_pw");
//			System.out.println("crypted_pw = "+crypted_pw);
//			System.out.println("saved_pw    = "+saved_pw);
			if (saved_pw.equals(crypted_pw)){
				System.out.println("===Password Chk OK===");
				String validexp = rtnvalue.get(0).get("validexp");
				if (validexp.equals("N")){
					throw new Exception("해당 계정의 사용기한이 만료 되었습니다. 관리자에게 문의 하여주십시오.");
				}
				
				
				
				List<StructMenuinfo> menuinfo = sqlSession.selectList("cert_0001.selectAuthMenus" , paramval);
				
				// 권한 부여 
				String authDV = rtnvalue.get(0).get("auth_dv"); 
				String deptNm = rtnvalue.get(0).get("dept");
				String usernm = rtnvalue.get(0).get("user_nm");
				
				 
								
				List<GrantedAuthority> roles = new ArrayList<GrantedAuthority>();
				// 기본으로 접속시 사용자 권한을 부여한다.
		        roles.add(new SimpleGrantedAuthority("ROLE_USER"));
		        
		        if (authDV.equals("2")) {
		        	roles.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
		        }else if(authDV.equals("3")){
		        	roles.add(new SimpleGrantedAuthority("ROLE_SUPER")); 
		        }
		        
		        String solutionType = "";
		        List<Map<String, String>> solTypeList =sqlSession.selectList("cert_0001.getSysMntCd");
		        solutionType  = solTypeList.get(0).get("sys_mnt_cd");
		        UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(user_id, user_pw, roles);
		        result.setDetails(new CustomUserDetails(user_id,usernm ,  user_pw , authDV , deptNm ,solutionType, menuinfo ));
		        
		        // 이력 남기기 
		        HashMap<String , String> putval = new HashMap<String, String>();
		        putval.put("user_id", user_id);
		        putval.put("user_nm", usernm );
		        putval.put("ip", reqip);
		        putval.put("login_gb", "1");
		        
		        
		        
		        sqlSession.insert("cert_0001.insLoginHis", putval);
				return result;
				
			}else{
				throw new BadCredentialsException("사용자 계정이 잘못되었거나 비밀번호가 일치하지 않습니다.");
			}*/
		} catch(DataAccessException e) {
			throw new BadCredentialsException("DX-TCONTROL DB 연결오류");
		} catch(Exception ex){
			throw new BadCredentialsException(ex.toString());
			
		}
		return authentication;
        
		
	}
}
