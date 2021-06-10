package com.experdb.management.recovery.cmmn;

import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.experdb.management.backup.policy.service.VolumeVO;

public class RestoreMake {
	
	// bmr restore
	public void bmr (RestoreInfoVO restore) throws IOException{
		
		System.out.println("#### BMR Write ####");
		FileWriter f = new FileWriter("C://test/"+ restore.getJobName() +".txt");
		
		String context;
		
		// restore info
		context = "job_name = " + restore.getJobName() + "\n"
				+ "storage_location_type = " + restore.getStorageLocation() + "\n"
				+ "source_node = " + restore.getSourceNode() + "\n"
				+ "recovery_point = " + restore.getRecoveryPoint() + "\n"
				+ "encryption_password = " + restore.getEncryptionPassword() + "\n"
				+ "restore_target = " + restore.getRestoreTarget() + "\n"
				+ "guest_network = " + restore.getGuestNetwork() + "\n"
				+ "guest_ip = " + restore.getGuestIp() + "\n"
				+ "guest_netmask = " + restore.getGuestNetmask() + "\n"
				+ "guest_gateway = " + restore.getGuestGateway() + "\n"
				+ "guest_dns = " + restore.getGuestDns() + "\n";
		
		// include volume
		String volume = "include_volumes = ";
		int volumeCount = 0;
		for (VolumeVO v : restore.getVolumes()){
			volume += v.getMountOn();
			volumeCount ++;
			if(volumeCount < restore.getVolumes().size()){
				volume += ":";
			}
		}
		volume += "\n";
		
		// file write
		f.write(context);
		f.write(volume);
		f.close();
		
		System.out.println("#### BMR Write End ####");
	}
	
	// file restore
	public void fileRestore(){
		System.out.println("#### FileRestore Write ####");
		
		System.out.println("#### FileRestore Write End ####");
	}
	
	// mount on restore
	public void mountOn(){
		System.out.println("#### MountOn Write ####");
		
		System.out.println("#### MountOn Write End ####");
	}
	
	public static void main(String[] args){
		RestoreMake rm = new RestoreMake();
		try {
			RestoreInfoVO ri = new RestoreInfoVO();
			
			Date date = new Date();
	        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	        String time = transFormat.format(date);
	        
	        List<VolumeVO> volumeList = new ArrayList<>();
	        VolumeVO volume1 = new VolumeVO();
	        VolumeVO volume2 = new VolumeVO();
	        VolumeVO volume3 = new VolumeVO();
	        volume1.setMountOn("/");
	        volumeList.add(volume1);
	        volume2.setMountOn("/boot");
	        volumeList.add(volume2);
	        volume3.setMountOn("/data");
	        volumeList.add(volume3);
	        
			ri.setJobName(time);
			ri.setStorageLocation("nfs");
			ri.setSourceNode("192.168.50.133");
			ri.setRecoveryPoint("last");
			ri.setEncryptionPassword("###");
			ri.setRestoreTarget("08:00:27:65:e6:fe");
			ri.setGuestNetwork("static");
			ri.setGuestIp("192.168.50.155");
			ri.setGuestNetmask("255.255.255.0");
			ri.setGuestGateway("192.168.50.1");
			ri.setGuestDns("8.8.8.8");
			ri.setVolumes(volumeList);
			
			rm.bmr(ri);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
