package com.k4m.dx.tcontrol.monitoring.resourceMgr;

import java.util.List;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;
import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.ProcState;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.SigarException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.CpuInfo;
import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.DiskInfo;
import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.FileDiskInfo;
import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.ManagedProcessInfo;
import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.MemoryInfo;
import com.k4m.dx.tcontrol.monitoring.resourceMgr.vo.ProcessInfo;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.06.28   박태혁 최초 생성
*      </pre>
*/
public class ResourceMgr {
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	private static ResourceMgr instance = new ResourceMgr();
	
	private Sigar sigar = new Sigar();
	
	private CpuInfo cpuInfo = new CpuInfo();
	private MemoryInfo memoryInfo = new MemoryInfo();
	private FileDiskInfo fileDiskInfo = new FileDiskInfo();
	private ManagedProcessInfo managedProcessInfo = new ManagedProcessInfo();
	
	private ResourceMgr(){}
	
	public static synchronized ResourceMgr getInstance(){
		return instance;
	}

	public CpuInfo getCpuInfo(){
		return cpuInfo;
	}

	public MemoryInfo getMemoryInfo() {
		return memoryInfo;
	}
	
	public FileDiskInfo getFileDiskInfo() {
		return fileDiskInfo;
	}
	
	public ManagedProcessInfo getManagedProcessInfo() {
		return managedProcessInfo;
	}
	
	public void loadResource(){
		try {
			CpuPerc[] percList = sigar.getCpuPercList();
			double idle = 0;
			for(CpuPerc perc : percList){
				idle += perc.getIdle()*100;
			}
			int usage = (int) (100 - idle/percList.length);
			cpuInfo.setUsage(usage);
			//socketLogger.debug("LoadResource|CPU|usage="+usage);
		} catch (SigarException e) {
			errLogger.error("RESOURCE ERROR|cann't load cpu usage",e);
		}
		
		try {
			int usage = (int) sigar.getMem().getUsedPercent();
			memoryInfo.setUsage(usage);
			//socketLogger.debug("LoadResource|MEMORY|usage"+usage);
		} catch (SigarException e) {
			errLogger.error("RESOURCE ERROR|cann't load memory usage",e);
		}

		try {
			FileSystem[] systems = sigar.getFileSystemList();
			List<DiskInfo> list = new Vector<DiskInfo>();
			for(FileSystem system : systems){
				try{
					DiskInfo info = new DiskInfo();
					info.setName(system.getDevName());
					FileSystemUsage systemUsage = sigar.getFileSystemUsage(system.getDevName());
					info.setUsedKbyte(systemUsage.getUsed());
					info.setTotalKbyte(systemUsage.getTotal());
					int usage = (int) (systemUsage.getUsePercent()*100) ;
					info.setUsage(usage);
					info.setType(system.getSysTypeName()+"/"+system.getTypeName());
					list.add(info);
					//socketLogger.debug("LoadResource|DISK|name="+system.getDevName()+",usage="+usage);
				}
				catch (SigarException e) {
					//logger.error("cann't load disk usage ["+remain.getDevName()+"]",e);
				}
			}
			fileDiskInfo.setDiskInfos(list);
		} catch (SigarException e) {
			errLogger.error("RESOURCE ERROR|cann't load disk info",e);
		}
		try {
			List<ProcessInfo> list = new Vector<ProcessInfo>();
			long[] pids = sigar.getProcList();
			for(long pid : pids){
				ProcessInfo info = new ProcessInfo();
				try{
					ProcState procState = sigar.getProcState(pid);
					info.setPid(pid);
					info.setName(procState.getName());
					String state = String.valueOf(procState.getState());
					ProcessInfo.STATE pState = ProcessInfo.STATE.get(state);
					String stateName = pState == null ?  state : pState.getDescription();
					info.setState(StringUtils.defaultIfEmpty(stateName, ""));
					
					try{
						String[] arguments = sigar.getProcArgs(pid);
						info.setArgument(StringUtils.join(arguments, " "));
					}
					catch(Exception e){
						info.setArgument("");
					}
					
					list.add(info);
					//socketLogger.debug("LoadResource|PROCESS|PID="+info.getPid()+",NAME="+info.getName()+",STATE="+info.getState()+",Argument="+info.getArgument());
				}
				catch(SigarException e){
					
				}
			}
			managedProcessInfo.setProcessInfos(list);
		}
		catch(SigarException e){
			errLogger.error("RESOURCE ERROR|cann't load process info",e);
		}
	}
}
