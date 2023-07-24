package comm.experdb.management.pgbackrest.backupinfo;

import com.sun.tools.javac.util.List;

public class Root {
    public List<Archive> archive;
    public List<PgBackrestInfo> backup;
    public String cipher;
    public List<Database> db;
    public String name;
    public List<Repo> repo;
    public Status status;
    
	public List<Archive> getArchive() {
		return archive;
	}
	public void setArchive(List<Archive> archive) {
		this.archive = archive;
	}
	public List<PgBackrestInfo> getBackup() {
		return backup;
	}
	public void setBackup(List<PgBackrestInfo> backup) {
		this.backup = backup;
	}
	public String getCipher() {
		return cipher;
	}
	public void setCipher(String cipher) {
		this.cipher = cipher;
	}
	public List<Database> getDb() {
		return db;
	}
	public void setDb(List<Database> db) {
		this.db = db;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Repo> getRepo() {
		return repo;
	}
	public void setRepo(List<Repo> repo) {
		this.repo = repo;
	}
	public Status getStatus() {
		return status;
	}
	public void setStatus(Status status) {
		this.status = status;
	}
}