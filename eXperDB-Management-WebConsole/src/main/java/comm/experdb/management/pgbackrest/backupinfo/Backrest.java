package comm.experdb.management.pgbackrest.backupinfo;

public class Backrest {
    public int format;
    public String version;
	
    public int getFormat() {
		return format;
	}
	public void setFormat(int format) {
		this.format = format;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
}