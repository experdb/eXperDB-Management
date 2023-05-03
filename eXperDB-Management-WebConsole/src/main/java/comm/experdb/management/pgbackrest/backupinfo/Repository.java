package comm.experdb.management.pgbackrest.backupinfo;

public class Repository {
    public int delta;
    public int size;
    public String convertSize;
    
	public int getDelta() {
		return delta;
	}
	public void setDelta(int delta) {
		this.delta = delta;
	}
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public String getConverSize() {
		return convertSize;
	}
	public void setConvertSize(String converSize) {
		this.convertSize = converSize;
	}
}