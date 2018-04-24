package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

/**
* AbstractPageModel
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

public class AbstractPageModel  extends AbstractManagedModel {
	private long pageSize = 50;
	private long pageOffset = 1;
	private long totalCountLimit = 10001;
	public long RowOffset;
	public long getPageSize() {
		return pageSize;
	}
	public void setPageSize(long pageSize) {
		this.pageSize = pageSize;
	}
	public long getPageOffset() {
		return pageOffset;
	}
	public void setPageOffset(long pageOffset) {
		this.pageOffset = pageOffset;
	}
	public long getTotalCountLimit() {
		return totalCountLimit;
	}
	public void setTotalCountLimit(long totalCountLimit) {
		this.totalCountLimit = totalCountLimit;
	}
	public long getRowOffset() {
		if (pageOffset > 0L)
		{
			return (pageOffset - 1L) * pageSize;
		}
		else
		{
			return 0L;
		}
	}
	public void setRowOffset(long rowOffset) {
		RowOffset = rowOffset;
	}
	
	
}
