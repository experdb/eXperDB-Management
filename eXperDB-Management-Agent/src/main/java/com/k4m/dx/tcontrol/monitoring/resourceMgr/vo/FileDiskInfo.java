package com.k4m.dx.tcontrol.monitoring.resourceMgr.vo;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.snmp4j.agent.mo.DefaultMOFactory;
import org.snmp4j.agent.mo.DefaultMOMutableRow2PC;
import org.snmp4j.agent.mo.DefaultMOMutableTableModel;
import org.snmp4j.agent.mo.DefaultMOTable;
import org.snmp4j.agent.mo.DefaultMOTableModel;
import org.snmp4j.agent.mo.DefaultMOTableRow;
import org.snmp4j.agent.mo.MOAccessImpl;
import org.snmp4j.agent.mo.MOColumn;
import org.snmp4j.agent.mo.MOFactory;
import org.snmp4j.agent.mo.MOMutableColumn;
import org.snmp4j.agent.mo.MOTable;
import org.snmp4j.agent.mo.MOTableIndex;
import org.snmp4j.agent.mo.MOTableRow;
import org.snmp4j.agent.mo.MOTableSubIndex;
import org.snmp4j.smi.Integer32;
import org.snmp4j.smi.OID;
import org.snmp4j.smi.OctetString;
import org.snmp4j.smi.SMIConstants;
import org.snmp4j.smi.UnsignedInteger32;
import org.snmp4j.smi.Variable;

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

public class FileDiskInfo {
	
	private static MOFactory moFactory = DefaultMOFactory.getInstance();
	private static final MOColumn[] hrDiskColumns = new MOColumn[] { 
		new MOMutableColumn(1, SMIConstants.SYNTAX_INTEGER, MOAccessImpl.ACCESS_READ_ONLY), 
		new MOMutableColumn(2, SMIConstants.SYNTAX_OCTET_STRING, MOAccessImpl.ACCESS_READ_ONLY), 
		new MOMutableColumn(3, SMIConstants.SYNTAX_INTEGER, MOAccessImpl.ACCESS_READ_ONLY),
		new MOMutableColumn(4, SMIConstants.SYNTAX_UNSIGNED_INTEGER32, MOAccessImpl.ACCESS_READ_ONLY),
		new MOMutableColumn(5, SMIConstants.SYNTAX_UNSIGNED_INTEGER32, MOAccessImpl.ACCESS_READ_ONLY),
		new MOMutableColumn(6, SMIConstants.SYNTAX_OCTET_STRING, MOAccessImpl.ACCESS_READ_ONLY)
	};
	private static final MOTableSubIndex[] hrDiskIndexes = new MOTableSubIndex[] { 
		moFactory.createSubIndex(null, SMIConstants.SYNTAX_INTEGER, 1, 32)
	};
	private static final MOTableIndex hrDiskIndex = moFactory.createIndex(hrDiskIndexes, true);
	
	private DefaultMOMutableTableModel<DefaultMOTableRow> diskTableModel = new DefaultMOMutableTableModel<DefaultMOTableRow>();
	
	public FileDiskInfo(){
	}
	
	public DefaultMOTable createDiskMOTable(OID index){
		return new DefaultMOTable(index, hrDiskIndex, hrDiskColumns, diskTableModel);
	}
	
	public void setDiskInfos(List<DiskInfo> list){
		synchronized(diskTableModel){
			diskTableModel.clear();
			Collections.sort(list);
			for(int idx=0; idx < list.size(); idx++){
				DiskInfo info = list.get(idx);
				OID oid = new OID(String.valueOf(idx+1));
				diskTableModel.addRow(
					new DefaultMOTableRow(
						oid, 
						new Variable[] { 
							new Integer32(oid.last()), 
							new OctetString(info.getName()), 
							new Integer32(info.getUsage()),
							new UnsignedInteger32(info.getTotalKbyte()),
							new UnsignedInteger32(info.getUsedKbyte()),
							new OctetString(info.getType())
						}
					)
				);
			}
		}
	}
}

