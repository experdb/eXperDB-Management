package com.experdb.management.recovery.cmmn;

import java.io.FileWriter;
import java.io.IOException;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

import com.experdb.management.backup.policy.service.VolumeVO;

public class RestoreMachineMake {
	
	public static void restoreMachineFile (RestoreInfoVO rm) throws IOException{
		
		StandardPBEStringEncryptor standardPBEStringEncryptor = new StandardPBEStringEncryptor();  
		
	    StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
	    pbeEnc.setPassword("k4mda"); // PBE 값(XML PASSWORD설정)
			
			System.out.println("#### RestorMachine Write ####");
			FileWriter f = new FileWriter("C://test/"+ rm.getGuestIp() +".txt");
			
			String context;
			
			// restore info
			context = "mac = " + pbeEnc.encrypt(rm.getGuestMac()) + "\n"
					+ "ip = " + pbeEnc.encrypt(rm.getGuestIp()) + "\n"
					+ "subnetmask = " + pbeEnc.encrypt(rm.getGuestSubnetmask()) + "\n"
					+ "gateway = " + pbeEnc.encrypt(rm.getGuestGateway()) + "\n"
					+ "dns = " + pbeEnc.encrypt(rm.getGuestDns()) + "\n"
					+ "netwrok = " + pbeEnc.encrypt(rm.getGuestNetwork()) + "\n";
			
			// file write
			f.write(context);
			f.close();
			
			System.out.println("#### RestorMachine Write End ####");
		}
	
	
	public static void main(String args[]) {
		try {
			RestoreInfoVO rm = new RestoreInfoVO();

	
		/* ============ Restore Target Infomation =============	*/
	    String mac  = "08:00:27:27:4d:b8"; 
	    String ip  = "192.168.50.201"; 
	    String subnetmask  = "255.255.255.0";    
	    String gateway  = "192.168.50.1 ";  
	    String dns  = "8.8.8.8";   
	    String netowrk  = "static"; 
	    /* =========================================	*/
	    
	    rm.setGuestMac(mac);
	    rm.setGuestIp(ip);
	    rm.setGuestSubnetmask(subnetmask);
	    rm.setGuestGateway(gateway);
	    rm.setGuestDns(dns);
	    rm.setGuestNetwork(netowrk);
	    
	    restoreMachineFile(rm);
	    	  	    
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
