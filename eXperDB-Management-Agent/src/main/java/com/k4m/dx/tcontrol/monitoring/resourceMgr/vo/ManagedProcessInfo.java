package com.k4m.dx.tcontrol.monitoring.resourceMgr.vo;

import java.util.Collections;
import java.util.List;

import org.snmp4j.agent.mo.DefaultMOFactory;
import org.snmp4j.agent.mo.DefaultMOMutableTableModel;
import org.snmp4j.agent.mo.DefaultMOTable;
import org.snmp4j.agent.mo.DefaultMOTableRow;
import org.snmp4j.agent.mo.MOAccessImpl;
import org.snmp4j.agent.mo.MOColumn;
import org.snmp4j.agent.mo.MOFactory;
import org.snmp4j.agent.mo.MOMutableColumn;
import org.snmp4j.agent.mo.MOTableIndex;
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

public class ManagedProcessInfo {


	private static MOFactory moFactory = DefaultMOFactory.getInstance();
	private static final MOColumn[] hrDiskColumns = new MOColumn[] { 
		new MOMutableColumn(1, SMIConstants.SYNTAX_INTEGER, MOAccessImpl.ACCESS_READ_ONLY), 
		new MOMutableColumn(2, SMIConstants.SYNTAX_UNSIGNED_INTEGER32, MOAccessImpl.ACCESS_READ_ONLY), 
		new MOMutableColumn(3, SMIConstants.SYNTAX_OCTET_STRING, MOAccessImpl.ACCESS_READ_ONLY),
		new MOMutableColumn(4, SMIConstants.SYNTAX_OCTET_STRING, MOAccessImpl.ACCESS_READ_ONLY),
		new MOMutableColumn(5, SMIConstants.SYNTAX_OCTET_STRING, MOAccessImpl.ACCESS_READ_ONLY)
	};
	private static final MOTableSubIndex[] hrDiskIndexes = new MOTableSubIndex[] { 
		moFactory.createSubIndex(null, SMIConstants.SYNTAX_INTEGER, 1, 32)
	};
	private static final MOTableIndex hrDiskIndex = moFactory.createIndex(hrDiskIndexes, true);
	
	private DefaultMOMutableTableModel<DefaultMOTableRow> diskTableModel = new DefaultMOMutableTableModel<DefaultMOTableRow>();
	
	public ManagedProcessInfo(){
	}
	
	public DefaultMOTable createProcessMOTable(OID index){
		return new DefaultMOTable(index, hrDiskIndex, hrDiskColumns, diskTableModel);
	}
	
	public void setProcessInfos(List<ProcessInfo> list){
		synchronized(diskTableModel){
			diskTableModel.clear();
			Collections.sort(list);
			for(int idx=0; idx < list.size(); idx++){
				ProcessInfo info = list.get(idx);
				OID oid = new OID(String.valueOf(idx+1));
				diskTableModel.addRow(
					new DefaultMOTableRow(
						oid, 
						new Variable[] { 
							new Integer32(oid.last()), 
							new UnsignedInteger32(info.getPid()),
							new OctetString(info.getName()),
							new OctetString(info.getArgument()),
							new OctetString(info.getState())
						}
					)
				);
			}
		}
	}

}
