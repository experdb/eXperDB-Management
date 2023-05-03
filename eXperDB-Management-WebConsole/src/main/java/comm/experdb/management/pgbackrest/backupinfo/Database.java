package comm.experdb.management.pgbackrest.backupinfo;

public class Database {
    public int id;
    public int repoKey;
	
    public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getRepoKey() {
		return repoKey;
	}
	public void setRepoKey(int repoKey) {
		this.repoKey = repoKey;
	}
}