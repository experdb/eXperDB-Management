package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Repository("CmmnHistoryDAO")
public class CmmnHistoryDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	public void insertHistoryLogin(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryLogin", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryLogout(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryLogout", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryMain(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryMain", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDbTree(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDbTree", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDbServer(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDbServer", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDbServerRegPopup(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDbServerRegPopup", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDbServerI(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDbServerI", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDatabase(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDatabase", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryTransferSetting(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryTransferSetting", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorRegister(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorRegister", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorRegisterU(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorRegisterU", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorRegisterD(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorRegisterD", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorRegPopup(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorRegPopup", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorRegisterI(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorRegisterI", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryConnectorConnTest(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryConnectorConnTest", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryUserManager(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryUserManager", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryUserManagerD(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryUserManagerD", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryUserManagerI(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryUserManagerI", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryUserManagerU(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryUserManagerU", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryMenuAuthority(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryMenuAuthority", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryDbAuthority(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryDbAuthority", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryAccessHistory(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryAccessHistory", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void insertHistoryAgentMonitoring(HistoryVO historyVO) {
		try {
			sqlMapClient.insert("cmmnHistorySQL.insertHistoryAgentMonitoring", historyVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
