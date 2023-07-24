package comm.experdb.management.pgbackrest.backupinfo;

public class Lock {
	
    public PgBackrestInfo backup;
    public boolean held;
    
	public PgBackrestInfo getBackup() {
		return backup;
	}
	public void setBackup(PgBackrestInfo backup) {
		this.backup = backup;
	}
	public boolean isHeld() {
		return held;
	}
	public void setHeld(boolean held) {
		this.held = held;
	}
}