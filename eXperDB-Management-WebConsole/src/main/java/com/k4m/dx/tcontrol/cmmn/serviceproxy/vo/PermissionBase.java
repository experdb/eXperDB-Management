package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import org.json.simple.JSONObject;

import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;

/**
* PermissionBase
* 
* 
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
public class PermissionBase extends AbstractManagedModel {

	@Expose
	private String	permissionKey;

	@Expose
	private String	permissionName;

	@Expose
	private Boolean	editPermissionTrueFalse;

	@Expose
	private Boolean	exportPermissionTrueFalse;

	@Expose
	private Boolean	viewPermissionTrueFalse;

	private String	permissionValue;

	@Expose
	private String	sysStatusCode;

	@Expose
	private int		displayOrder;

	public String getPermissionKey() {
		return permissionKey;
	}

	public void setPermissionKey(String permissionKey) {
		this.permissionKey = permissionKey;
	}

	public String getPermissionName() {
		return permissionName;
	}

	public void setPermissionName(String permissionName) {
		this.permissionName = permissionName;
	}

	public Boolean getEditPermissionTrueFalse() {
		return editPermissionTrueFalse;
	}

	public void setEditPermissionTrueFalse(Boolean editPermissionTrueFalse) {
		this.editPermissionTrueFalse = editPermissionTrueFalse;
	}

	public Boolean getExportPermissionTrueFalse() {
		return exportPermissionTrueFalse;
	}

	public void setExportPermissionTrueFalse(Boolean exportPermissionTrueFalse) {
		this.exportPermissionTrueFalse = exportPermissionTrueFalse;
	}

	public Boolean getViewPermissionTrueFalse() {
		return viewPermissionTrueFalse;
	}

	public void setViewPermissionTrueFalse(Boolean viewPermissionTrueFalse) {
		this.viewPermissionTrueFalse = viewPermissionTrueFalse;
	}

	public String getSysStatusCode() {
		return sysStatusCode;
	}

	public void setSysStatusCode(String sysStatusCode) {
		this.sysStatusCode = sysStatusCode;
	}

	public int getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}

	private void parsePermission() {

		if (TypeUtility.isEmpty(permissionValue)) {
			editPermissionTrueFalse = false;
			viewPermissionTrueFalse = false;
			exportPermissionTrueFalse = false;
		} else {
			PermissionBase permission = (new GsonBuilder().disableHtmlEscaping().create()).fromJson(permissionValue, PermissionBase.class);
			setEditPermissionTrueFalse(permission.editPermissionTrueFalse);
			setViewPermissionTrueFalse(permission.viewPermissionTrueFalse);
			setExportPermissionTrueFalse(permission.exportPermissionTrueFalse);
		}
	}

	private void makePermission() {
		JSONObject j = new JSONObject();
		j.put("editPermissionTrueFalse", editPermissionTrueFalse);
		j.put("viewPermissionTrueFalse", viewPermissionTrueFalse);
		j.put("exportPermissionTrueFalse", exportPermissionTrueFalse);

		permissionValue = j.toJSONString();
	}

	public String getPermissionValue() {
		makePermission();
		return permissionValue;
	}

	public void setPermissionValue(String permissionValue) {
		this.permissionValue = permissionValue;
		parsePermission();
	}
}
