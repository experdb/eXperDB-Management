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
			
			String mac =  pbeEnc.encrypt(rm.getGuestMac());
			String ip = pbeEnc.encrypt(rm.getGuestIp());
			String subnetmask =pbeEnc.encrypt(rm.getGuestSubnetmask());
			String gateway = pbeEnc.encrypt(rm.getGuestGateway());
			String dns = pbeEnc.encrypt(rm.getGuestDns());
			String network = pbeEnc.encrypt(rm.getGuestNetwork());
			
				
			// restore info
			context = "mac = " + mac + "\n"
					+ "ip = " + ip + "\n"
					+ "subnetmask = " + subnetmask + "\n"
					+ "gateway = " + gateway + "\n"
					+ "dns = " + dns + "\n"
					+ "network = " + network + "\n";
			
			
			System.out.println("-------------------------------------------------");
			System.out.println("MAC = "+mac);
			System.out.println("IP = "+ip);
			System.out.println("SubnetMask = "+subnetmask);
			System.out.println("Gateway = "+gateway);
			System.out.println("DNS = "+dns);
			System.out.println("Network = "+network);
			System.out.println("-------------------------------------------------");
			
			System.out.println("");
			
			System.out.println("-------------------------------------------------");
			System.out.println("MAC = "+pbeEnc.decrypt(mac));
			System.out.println("IP = "+pbeEnc.decrypt(ip));
			System.out.println("SubnetMask = "+pbeEnc.decrypt(subnetmask));
			System.out.println("Gateway = "+pbeEnc.decrypt(gateway));
			System.out.println("DNS = "+pbeEnc.decrypt(dns));
			System.out.println("Network = "+pbeEnc.decrypt(network));
			System.out.println("-------------------------------------------------");
			
			// file write
			f.write(context);
			f.close();
			
			System.out.println("#### RestorMachine Write End ####");
		}
	
	public RestoreInfoVO restoreInfoDecrypt(RestoreInfoVO rm){
		StandardPBEStringEncryptor pbeDnc = new StandardPBEStringEncryptor();
		pbeDnc.setPassword("k4mda"); 
		RestoreInfoVO result = new RestoreInfoVO();
		
		String mac =  pbeDnc.decrypt(rm.getGuestMac());
		String ip = pbeDnc.decrypt(rm.getGuestIp());
		String subnetmask =pbeDnc.decrypt(rm.getGuestSubnetmask());
		String gateway = pbeDnc.decrypt(rm.getGuestGateway());
		String dns = pbeDnc.decrypt(rm.getGuestDns());
		String network = pbeDnc.decrypt(rm.getGuestNetwork());
		String id = rm.getMachineId();
		
//		System.out.println("-------------------------------------------------");
//		System.out.println("MAC = "+mac);
//		System.out.println("IP = "+ip);
//		System.out.println("SubnetMask = "+subnetmask);
//		System.out.println("Gateway = "+gateway);
//		System.out.println("DNS = "+dns);
//		System.out.println("Network = "+network);
//		System.out.println("-------------------------------------------------");
		
		result.setGuestMac(mac);
		result.setGuestIp(ip);
		result.setGuestSubnetmask(subnetmask);
		result.setGuestGateway(gateway);
		result.setGuestDns(dns);
		result.setGuestNetwork(network);
		result.setMachineId(id);
		
		return result;
		
	}
	
	public RestoreInfoVO restoreInfoEncrypt(RestoreInfoVO rm){
		StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
		pbeEnc.setPassword("k4mda"); 
		RestoreInfoVO result = new RestoreInfoVO();
		
		String mac =  pbeEnc.encrypt(rm.getGuestMac());
		String ip = pbeEnc.encrypt(rm.getGuestIp());
		String subnetmask =pbeEnc.encrypt(rm.getGuestSubnetmask());
		String gateway = pbeEnc.encrypt(rm.getGuestGateway());
		String dns = pbeEnc.encrypt(rm.getGuestDns());
		String network = pbeEnc.encrypt(rm.getGuestNetwork());
		
		System.out.println("-------------------------------------------------");
		System.out.println("MAC = "+mac);
		System.out.println("IP = "+ip);
		System.out.println("SubnetMask = "+subnetmask);
		System.out.println("Gateway = "+gateway);
		System.out.println("DNS = "+dns);
		System.out.println("Network = "+network);
		System.out.println("-------------------------------------------------");
		
		result.setGuestMac(mac);
		result.setGuestIp(ip);
		result.setGuestSubnetmask(subnetmask);
		result.setGuestGateway(gateway);
		result.setGuestDns(dns);
		result.setGuestNetwork(network);
		
		return result;
	}
	
	
	public static void main(String args[]) {
		try {
			RestoreInfoVO rm = new RestoreInfoVO();

	
		/* ============ Restore Target Infomation =============	*/
	    String mac  = "08:00:27:17:7a:84"; 
	    String ip  = "192.168.50.100"; 
	    String subnetmask  = "255.255.255.0";    
	    String gateway  = "192.168.50.0";  
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
