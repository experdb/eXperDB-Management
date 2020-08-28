<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="./cmmn/cs2.jsp"%>

<script src="/vertical-dark-sidebar/js/dashboard_common.js"></script>

<script type="text/javascript">

	
	$(window.document).ready(function() { 

		fn_gData("${result.CMD_TABLESPACE_INFO[0].use}");
		fn_gBackup("${result.CMD_BACKUPSPACE_INFO[0].fsize}", "${result.BACKUP_V}");
		fn_gWal("${result.PGWAL_CNT}", "${result.WAL_KEEP_SEGMENTS} ");
		fn_gArc("${result.PGALOG_V}");
		fn_gLog("${result.LOG_V}");
		fn_gDump("${result.PGDBAK_V}");

	});


	
</script>



<!-- partial -->
<div class="content-wrapper main_scroll">
	<div class="row" style="margin-top:-20px;margin-bottom:5px;">
		<!-- title start -->
		<div class="accordion_main accordion-multi-colored col-12" sid="accordion" role="tablist">
			<div class="card" style="margin-bottom:0px;">
				<div class="card-header" role="tab" id="page_header_div" >
					<div class="row" style="height: 15px;">
						<div class="col-5">
							<h6 class="mb-0">
								<i class="ti-calendar menu-icon"></i>
								<span class="menu-title"><spring:message code="etc.etc44"/></span>
							</h6>
						</div>
						<div class="col-7">
		 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
								<li class="breadcrumb-item_main" style="font-size: 0.875rem;" aria-current="page" id="tot_sdt_today"></li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	 <div class="row">
	 		<!-- DATA -->
            <div class="col-md-2_1 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
					 <table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">DATA</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                           <td class="text-muted pl-0"><i class="fa fa-hdd-o text-primary">${result.CMD_TABLESPACE_INFO[0].filesystem}</i> </td>
                        </tr>                
                      </tbody>
                    </table>
                    <table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">Size</th>
                          <th class="border-bottom">Used</th>
                          <th class="border-bottom">Avail</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="text-muted pl-0">${result.CMD_TABLESPACE_INFO[0].fsize}</td>
                          <td class="text-muted">${result.CMD_TABLESPACE_INFO[0].used}</td>
                          <td class="text-muted">${result.CMD_TABLESPACE_INFO[0].avail}</td>  
                        </tr>                      
                      </tbody>
                    </table>
                    <p class="mb-0 mt-2 text-warning">사용량</p>	
                     <div id="pg_data" class="gauge"  style="margin-top: -40px;"></div>                    
                  </div>
                </div>
              </div>
            </div>
                       
            <!-- BAUKUP -->
            <div class="col-md-2_1 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
                     <table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">BAUKUP</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                           <td class="text-muted pl-0"><i class="fa fa-hdd-o text-primary">${result.BACKUP_PATH}</i> </td>
                        </tr>                
                      </tbody>
                    </table>
                    <table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">Size</th>
                          <th class="border-bottom">Used</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="text-muted pl-0">${result.CMD_BACKUPSPACE_INFO[0].fsize}</td>
                          <td class="text-muted">${result.BACKUP_V}</td>
                        </tr>                      
                      </tbody>
                    </table>
                    <p class="mb-0 mt-2 text-warning">사용량</p>	
                     <div id="pg_backup" class="gauge"  style="margin-top: -40px;"></div>                   
                  </div>
                </div>
              </div>
            </div>
            
            <!-- WAL  -->
            <div class="col-md-2_1 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
	 				<table class="table table-borderless">
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">WAL</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                           <td class="text-muted pl-0"><i class="fa fa-hdd-o text-primary">${result.PGWAL_PATH}</i> </td>
                        </tr>                
                      </tbody>
                    </table>    
                     <table class="table table-borderless">
                      <thead>
                         <tr>
                           <th class="text-muted pl-0"> <i class="ti-files"> WAL_KEEP_SEGMENTS : </i>  ${result.WAL_KEEP_SEGMENTS} 개</th>
                        </tr>    
                        <tr>
                           <th class="text-muted pl-0"> <i class="ti-files"> WAL_FILE : </i>   ${result.PGWAL_CNT} 개</th>
                        </tr> 
                      </thead>
                    </table>  
                    <p class="mb-0 mt-2 text-warning">WAL파일</p>	
                     <div id="pg_wal" class="gauge"  style="margin-top: -40px;"></div>                  
                  </div>
                </div>
              </div>
            </div>
            
            <!-- ARCHIVE -->
            <div class="col-md-2_1 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body">
                  <div class="table-responsive">
                     <table class="table table-borderless" >
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">ARCHIVE</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                           <td class="text-muted pl-0"> <i class="fa fa-hdd-o text-primary"> ${result.PGALOG_PATH} </i> </td>
                        </tr>                      
                      </tbody>
                    </table>
                    <table class="table table-borderless" style="margin-bottom: 50px">
                      <thead>
                         <tr>
                           <th class="text-muted pl-0"> <i class="ti-files"> ARCHIVE_FILE :  </i>  ${result.PGALOG_CNT} 개</th>
                        </tr>    
                      </thead>
                    </table>
                    <p class="mb-0 mt-2 text-warning">디렉토리 용량</p>
                     <div id="pg_arc" class="gauge"  style="margin-top: -40px;"></div>                   
                  </div>
                </div>
              </div>
            </div>
            
            <!-- LOG -->
            <div class="col-md-2_1 stretch-card grid-margin grid-margin-md-0">
              <div class="card">
                <div class="card-body"> 
                  <div class="table-responsive">
                    <table class="table table-borderless" >
                      <thead>
                        <tr>
                          <th class="pl-0 border-bottom">LOG</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="text-muted pl-0"> <i class="fa fa-hdd-o text-primary"> ${result.LOG_PATH} </i> </td>
                        </tr>                      
                      </tbody>
                    </table>  
                    <table class="table table-borderless" style="margin-bottom: 50px">
                      <thead>
                         <tr>
                           <th class="text-muted pl-0"> <i class="ti-files"> LOG_FILE :  </i>  ${result.LOG_CNT} 개</th>
                        </tr>    
                      </thead>
                    </table>  
                    <p class="mb-0 mt-2 text-warning">디렉토리 용량</p>
                     <div id="pg_log" class="gauge"  style="margin-top: -40px;"></div>                     
                  </div>
                </div>
              </div>
            </div>
            
     </div>
 </div>	    
     