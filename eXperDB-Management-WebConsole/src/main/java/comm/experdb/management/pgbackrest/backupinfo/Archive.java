package comm.experdb.management.pgbackrest.backupinfo;

public class Archive {
    public String start;
    public String stop;
	
    public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getStop() {
		return stop;
	}
	public void setStop(String stop) {
		this.stop = stop;
	}
}