package com.experdb.proxy.deamon;

import java.io.File;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public class DxDaemonManager {
	private Logger invokeLogger = LoggerFactory.getLogger("DaemonStartLogger");
	//private Logger invokeLogger = LoggerFactory.getLogger(DxDaemonManager.class.getName());

	/** 종료 표시자 파일의 존재 여부를 검사하는 주기 */
	private static int DEFAULT_FILE_POLLING_INTERVAL = 2;

	/**
	 * 한 JVM에는 단 한개의 DxDaemonManager 객체잔 존재한다. 그 단 한개의 객체.
	 */
	private static DxDaemonManager instance = null;

	/**
	 * 작업을 수행할 데몬의 Class 객체
	 */
	private Class dxDaemonClass = null;
	
	/**
	 * 실제로 작업을 수행할 데몬의 객체
	 */
	private DxDaemon dxDaemon = null;

	/**
	 * 데몬을 대표하는 락 파일과 종료 표시자 파일의 이름을 구성하는 문자열
	 */
	private String representName = null;

	/**
	 * 로거
	 */
	private DxLogger log = null;

	/**
	 * initialize() 메소드가 호출 되었는가?
	 */
	private boolean initialized = false;

	/**
	 * <p>
	 * DxDaemon을 초기화한다.
	 * </p>
	 * <p>
	 * 이 클래스는 getInstance() 메소드에 의해서만 객체를 생성할 수 있다.
	 * </p>
	 * 
	 * @@param sd
	 *            데몬으로 실행할 객체.
	 */
	private DxDaemonManager(Class daemonClass) {
		dxDaemonClass = daemonClass;
		log = DxLogger.getLogger();
	}

	/**
	 * <p>
	 * DxDaemonManager의 객체를 생성한다.
	 * </p>
	 * <p>
	 * 한 JVM에는 단 한개의 DxDaemonManager만 존재할 수 있다.
	 * 
	 * @@param daemonClass 데몬으로 실행될 클래스
	 * @@return DxDaemonManager의 인스턴스
	 * @@throws LockFileExistException
	 */
	public static synchronized DxDaemonManager getInstance(Class daemonClass)
		throws IllegalDxDaemonClassException {
		
		if (instance != null) {
			return instance;
		}
		
		if (!isDxDaemonClass(daemonClass)) {
			throw new IllegalDxDaemonClassException(daemonClass);
		}
		
		instance = new DxDaemonManager(daemonClass);

		return instance;
	}
	
	/**
	 * 주어진 클래스가 DxDaemon 인터페이스를 구현하고 있는가?
	 * 
	 * @@param daemonClass Class객체
	 * @@return DxDaemon 인터페이스 구현 여부
	 */
	public static boolean isDxDaemonClass(Class daemonClass) {
		Class [] interfaces = daemonClass.getInterfaces();
		
		boolean isDxDaemonClass = false;
		
		for (int i = 0; i < interfaces.length; i++) {
			if (interfaces[i].equals(DxDaemon.class)) {
				isDxDaemonClass = true;
				break;
			}
		}
		
		return isDxDaemonClass;
	}

	/**
	 * 데몬을 시작시킨다.
	 * @@throws LockFileExistException
	 * @@throws IOException
	 * @@throws IllegalDxDaemonClassException
	 */
	public void start() throws LockFileExistException, IOException, IllegalDxDaemonClassException {
		initialize();

		//프로젝트 디렉터리 체크
		//dxDaemon.chkDir();
		
		// 데몬을 실제로 실행한다.
		dxDaemon.startDaemon();
		
	}

	/**
	 * DxDaemonManager 객체 생성시 초기화를 수행한다.
	 * 
	 * @@throws LockFileExistException
	 * @@throws IOException
	 * @@throws IllegalDxDaemonClassException
	 */
	protected synchronized void initialize() throws LockFileExistException,
			IOException, IllegalDxDaemonClassException {
		if (initialized) {
			invokeLogger.info("이미 initialize() 메소드를 호출 했었습니다.");
			return;
		}

		try {
			// 작업을 수행할 DxDaemon 객체 생성
			dxDaemon = (DxDaemon)dxDaemonClass.newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new IllegalDxDaemonClassException(dxDaemonClass, e);			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			throw new IllegalDxDaemonClassException(dxDaemonClass, e);
		}
		
		File lockFile = getLockFile();
		if (lockFile.exists()) {
			// 락파일이 존재하면 종료해야한다.
			throw new LockFileExistException(lockFile);
		}

		// 락 파일 생성
		invokeLogger.info(lockFile.getAbsolutePath() + " 락 파일을 생성합니다.");

		if (!lockFile.createNewFile()) {
			String err = lockFile.getAbsolutePath() + " 락 파일 생성에 실패했습니다.";
			invokeLogger.info(err);
			throw new IOException(err);
		}

		File exitFlagFile = getExitFlagFile();
		if (exitFlagFile.exists()) {
			invokeLogger.info(exitFlagFile.getAbsolutePath() + " 종료 표시자 파일이 존재합니다. 삭제합니다.");

			if (!exitFlagFile.delete()) {
				String err = exitFlagFile.getAbsolutePath() + " 종료 표시자 파일 삭제에 실패했습니다.";
				invokeLogger.info(err);
				throw new IOException(err);
			}
		}

		// JVM 종료시 자동으로 실행해야할 작업들
		Runtime.getRuntime().addShutdownHook(new DxDaemonShutdownManager());

		// 종료 표시자 파일의 존재를 계속 검사하는 쓰레드
		ExitFlagFilePoll effp = new ExitFlagFilePoll(
				DEFAULT_FILE_POLLING_INTERVAL);
		
		effp.setDaemon(true);
		effp.start();
	}

	/**
	 * 데몬이 실행중인지 여부를 표시하는 락 파일의 이름을 리턴한다.
	 * 
	 * @@return 락 파일 이름
	 */
	protected String getLockFileName() {
		String lockFileName = getRepresentName() + ".lock";
		
		return lockFileName;
	}

	/**
	 * 락 파일의 객체를 리턴한다.
	 * 
	 * @@return 락 파일의 객체
	 */
	protected File getLockFile() {
		File lockFile = new File(getLockFileName());
		return lockFile;
	}

	/**
	 * 종료 표시자 파일의 이름을 리턴한다.
	 * 
	 * @@return 종료 표시자 파일의 이름
	 */
	protected String getExitFlagFileName() {
		String exitFlagFileName = getRepresentName() + ".shutdown";
		
		return exitFlagFileName;

	}

	/**
	 * 종료 표시자 파일의 객체를 리턴한다.
	 * 
	 * @@return 종료 표시자 파일의 객체
	 */
	protected File getExitFlagFile() {
		File exitFlagFile = new File(getExitFlagFileName());
		return exitFlagFile;
	}
	
	/**
	 * 데몬을 대표하는 락 파일과 종료 표시자 파일의 이름을 구성하는 문자열을 리턴한다.
	 * 
	 * @@return 데몬 대표 문자열
	 */
	protected synchronized String getRepresentName() {
		if (representName != null) {
			return representName;
		}
		
		String home = System.getProperty("user.home");

		String className = dxDaemonClass.getName();

		representName = home + File.separator + ".DX-TcontrolAgent_" + className;

		return representName;
	}

	/**
	 * JVM이 종료할 때 실행되어야 하는 작업을 지정한다.
	 */
	protected class DxDaemonShutdownManager extends Thread {

		public void run() {
			DxLogger log = DxLogger.getLogger();

			invokeLogger.info("데몬의 shutdown() 메소드 호출합니다.");
			dxDaemon.shutdown();

			File lockFile = getLockFile();
			invokeLogger.info(lockFile.getAbsolutePath() + " 락 파일 삭제를 시도합니다.");

			if (lockFile.exists()) {
				if (lockFile.delete()) {
					invokeLogger.info(lockFile.getAbsolutePath() + " 락 파일을 삭제했습니다.");
				} else {
					invokeLogger.info(lockFile.getAbsolutePath() + " 락 파일 삭제에 실패했습니다.");
				}

			} else {
				invokeLogger.info(lockFile.getAbsolutePath() + " 락 파일이 존재하지 않습니다.");
			}
			
			File exitFlagFile = getExitFlagFile();
			invokeLogger.info(exitFlagFile.getAbsolutePath() + " 종료 표시자 파일의 삭제를 시도합니다.");
			
			if (exitFlagFile.exists()) {
				if (exitFlagFile.delete()) {
					invokeLogger.info(exitFlagFile.getAbsolutePath()
							+ " 종료 표시자 파일을 삭제했습니다.");
				} else {
					invokeLogger.info(exitFlagFile.getAbsolutePath()
							+ " 종료 표시자 파일 삭제에 실패했습니다.");
				}
			}

			invokeLogger.info("데몬의 종료가 완료되었습니다.");
			invokeLogger.info("");
		}
	}

	/**
	 * 종료 표시자 파일이 생성되었는지 주기적으로 검사하는
	 * 쓰레드.
	 * 
	 */
	protected class ExitFlagFilePoll extends Thread {

		private int intervalms = 0;

		public ExitFlagFilePoll(int interval) {
			if (interval > 0) {
				this.intervalms = interval * 1000;
			} else {
				this.intervalms = DEFAULT_FILE_POLLING_INTERVAL * 1000;
			}
		}

		/**
		 * 종료 표시자 파일의 존재를 기다린다.
		 */
		public void run() {
			invokeLogger.info("데몬 종료 표시자 파일 감시 쓰레드를 시작했습니다.");
			
			while (true) {
				File exitFlagFile = getExitFlagFile();

				if (exitFlagFile.exists()) {
					invokeLogger.info(getExitFlagFileName() + " 가 생성되었습니다. " + 
							"시스템을 종료를 시작합니다 .");

					// 정말로 종료해버린다!
					System.exit(0);
				}

				try {
					Thread.sleep(intervalms);
				} catch (Exception ex) {
					ex.printStackTrace();
					//ignored
				}
			}
		}
	}

	/**
	 * <p>데몬을 종료시킨다.</p>
	 * 
	 * <p>이 메소드를 실행하면 현재 JVM의 데몬이 종료되는 것이 아니라,
	 * 이미 다른 JVM에서 실행중인 데몬의 종표 표시자 파일을 생성하여,
	 * 다른 JVM의 데몬을 종료시키는 것이다.</p>
	 */
	public void shutdownDaemon() throws IOException {
			File exitFlagFile = getExitFlagFile();
			
			if (exitFlagFile.exists()) {
				invokeLogger.info(exitFlagFile.getAbsolutePath() + "가 이미 존재합니다.");
				return;
			}
			
			try {
				exitFlagFile.createNewFile();
			} catch (IOException ex) {
				String err = exitFlagFile.getAbsolutePath() + " 생성에 실패했습니다.";
				invokeLogger.info(err);
				
				throw new IOException(err);
			}
			
			invokeLogger.info(exitFlagFile.getAbsolutePath() + " 를 생성했습니다. " + " 데몬이 곧 종료될 것입니다.");

	}

}
