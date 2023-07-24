package comm.experdb.management.pgbackrest.backupinfo;

public class Timestamp {
    public int start;
    public int stop;
    public String convertStart;
    public String convertStop;
    public String difference;
	
    public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getStop() {
		return stop;
	}
	public void setStop(int stop) {
		this.stop = stop;
	}
	public String getConvertStart() {
		return convertStart;
	}
	public void setConvertStart(String converStart) {
		this.convertStart = converStart;
	}
	public String getConvertStop() {
		return convertStop;
	}
	public void setConvertStop(String convertStop) {
		this.convertStop = convertStop;
	}
	public String getDifference() {
		return difference;
	}
	public void setDifference(String difference) {
		this.difference = difference;
	}
}