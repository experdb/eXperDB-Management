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
		
//		String path = "C://test/"+ restore.getJobName() +".txt";
		String path = "/opt/Arcserve/d2dserver/bin/jobs/" + restore.getJobName() + ".txt";
		
		FileWriter f = new FileWriter(path);
		
		String context;
		String content_info;
		String content_storage;
		String content_guest;
		String content_rps;
		String content_script;
		
		// restore info
		content_info = "########## info ##########\n"
				+ "job_name = " + restore.getJobName() + "\n"
				+ "source_node = " + restore.getSourceNode() + "\n"
				+ "enable_instant_restore = " + restore.getBmr() + "\n"
				+ "#auto_restore_data = " + "\n"
				+ "restore_target = " + restore.getGuestMac() + "\n"
				+ "recovery_point = " + restore.getRecoveryPoint() + "\n";
		
		// storage
		content_storage = "########## storage ##########\n"
				+ "storage_location_type = " + restore.getStorageType() + "\n"
				+ "storage_location = " + restore.getStorageLocation() + "\n"
				+ "#storage_username = " + "\n"
				+ "#storage_password = " + "\n";
		
		// recoveryDB information
		content_guest = "########## recoveryDB ##########\n"
				+ "guest_network = " + restore.getGuestNetwork() + "\n"
				+ "guest_ip = " + restore.getGuestIp() + "\n"
				+ "guest_netmask = " + restore.getGuestSubnetmask() + "\n"
				+ "guest_gateway = " + restore.getGuestGateway() + "\n"
				+ "guest_dns = " + restore.getGuestDns() + "\n"
				+ "#guest_hostname = " + "\n"
				+ "#guest_reboot = " + "\n"
				+ "#guest_reset_username = " + "\n"
				+ "#guest_reset_password = " + "\n";
		
		// rps backup
		content_rps = "########## rps ###########\n"
				+ "#rps_server_password = " + "\n"
				+ "#rps_server_protocol = " + "\n"
				+ "#rps_server_port = " + "\n"
				+ "#rps_server = " + "\n"
				+ "#rps_server_username = " + "\n"
				+ "#rps_server_datastore = " + "\n";
		
		// script
		content_script = "########## script ##########\n"
				+ "#script_pre_job_server = " + "\n"
				+ "#script_post_job_server = " + "\n"
				+ "#script_pre_job_client = " + "\n"
				+ "#script_post_job_client = " + "\n"
				+ "#script_ready_to_use = " + "\n";
		
		
		// include volume
//		String volume = "include_volumes = ";
//		int volumeCount = 0;
//		if(restore.getVolumes() != null){			
//			for (VolumeVO v : restore.getVolumes()){
//				volume += v.getMountOn();
//				volumeCount ++;
//				if(volumeCount < restore.getVolumes().size()){
//					volume += ":";
//				}
//			}
//		}
//		volume += "\n";
		
		context = content_info + content_storage + content_guest + content_rps + content_script;
		
		// file write
		f.write(context);
		//f.write(volume);
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
