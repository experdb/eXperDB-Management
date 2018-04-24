package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class Resource extends AbstractManagedModel {

	@Expose
	private String	resourceUid;

	@Expose
	private String	parentUid;

	@Expose
	private String	resourceName;

	@Expose
	private String	resourceNote;

	@Expose
	private String	resourceTypeCode;

	@Expose
	private String	resourceTypeName;

	@Expose
	private String	containerTypeCode;

	@Expose
	private String	containerTypeName;

	@Expose
	private String	resourceStatusCode;

	@Expose
	private String	resourceStatusName;

	public String getResourceUid() {
		return resourceUid;
	}

	public void setResourceUid(String resourceUid) {
		this.resourceUid = resourceUid;
	}

	public String getParentUid() {
		return parentUid;
	}

	public void setParentUid(String parentUid) {
		this.parentUid = parentUid;
	}

	public String getResourceName() {
		return resourceName;
	}

	public void setResourceName(String resourceName) {
		this.resourceName = resourceName;
	}

	public String getResourceNote() {
		return resourceNote;
	}

	public void setResourceNote(String resourceNote) {
		this.resourceNote = resourceNote;
	}

	public String getResourceTypeCode() {
		return resourceTypeCode;
	}

	public void setResourceTypeCode(String resourceTypeCode) {
		this.resourceTypeCode = resourceTypeCode;
	}

	public String getResourceTypeName() {
		return resourceTypeName;
	}

	public void setResourceTypeName(String resourceTypeName) {
		this.resourceTypeName = resourceTypeName;
	}

	public String getContainerTypeCode() {
		return containerTypeCode;
	}

	public void setContainerTypeCode(String containerTypeCode) {
		this.containerTypeCode = containerTypeCode;
	}

	public String getContainerTypeName() {
		return containerTypeName;
	}

	public void setContainerTypeName(String containerTypeName) {
		this.containerTypeName = containerTypeName;
	}

	public String getResourceStatusCode() {
		return resourceStatusCode;
	}

	public void setResourceStatusCode(String resourceStatusCode) {
		this.resourceStatusCode = resourceStatusCode;
	}

	public String getResourceStatusName() {
		return resourceStatusName;
	}

	public void setResourceStatusName(String resourceStatusName) {
		this.resourceStatusName = resourceStatusName;
	}

	public static Resource fromString(String jsonString) {
		return fromString(jsonString, Resource.class);
	}

}
