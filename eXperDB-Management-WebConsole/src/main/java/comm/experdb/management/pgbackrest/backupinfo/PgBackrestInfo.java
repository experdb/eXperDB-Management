package comm.experdb.management.pgbackrest.backupinfo;

public class PgBackrestInfo {
    public Archive archive;
    public Backrest backrest;
    public Database database;
    public boolean error;
    public Info info;
    public String label;
    public Lsn lsn;
    public Object prior;
    public Object reference;
    public Timestamp timestamp;
    public String type;
    
	public Archive getArchive() {
		return archive;
	}
	public void setArchive(Archive archive) {
		this.archive = archive;
	}
	public Backrest getBackrest() {
		return backrest;
	}
	public void setBackrest(Backrest backrest) {
		this.backrest = backrest;
	}
	public Database getDatabase() {
		return database;
	}
	public void setDatabase(Database database) {
		this.database = database;
	}
	public boolean isError() {
		return error;
	}
	public void setError(boolean error) {
		this.error = error;
	}
	public Info getInfo() {
		return info;
	}
	public void setInfo(Info info) {
		this.info = info;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public Lsn getLsn() {
		return lsn;
	}
	public void setLsn(Lsn lsn) {
		this.lsn = lsn;
	}
	public Object getPrior() {
		return prior;
	}
	public void setPrior(Object prior) {
		this.prior = prior;
	}
	public Object getReference() {
		return reference;
	}
	public void setReference(Object reference) {
		this.reference = reference;
	}
	public Timestamp getTimestamp() {
		return timestamp;
	}
	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}