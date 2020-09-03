<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- title start -->
<div class="accordion_main accordion-multi-colored" id="accordion" role="tablist">
	<div class="card">
		<div class="card-header" role="tab" id="page_header_div">
			<div class="row">
				<div class="col-5">
					<h6 class="mb-0">
						<a data-toggle="collapse" href="#page_header_sub" aria-expanded="false" aria-controls="page_header_sub" onclick="fn_profileChk('titleText')">
							<i class="fa fa-check-square"></i>
							<span class="menu-title">서버마스터키 암호화 설정</span>
							<i class="menu-arrow_user" id="titleText" ></i>
						</a>
					</h6>
				</div>
				<div class="col-7">
 					<ol class="mb-0 breadcrumb_main justify-content-end bg-info" >
 						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">MIGRATION</li>
						<li class="breadcrumb-item_main" style="font-size: 0.875rem;">MIGRATION</li>
						<li class="breadcrumb-item_main active" style="font-size: 0.875rem;" aria-current="page">설정정보관리</li>
					</ol>
				</div>
			</div>
		</div>
		
		<div id="page_header_sub" class="collapse" role="tabpanel" aria-labelledby="page_header_div" data-parent="#accordion">
			<div class="card-body">
				<div class="row">
					<div class="col-12">
						<p class="mb-0">123서버에 생성된 설정정보관리 작업을 조회하거나 신규로 등록 또는 삭제 합니다.</p>
						<p class="mb-0">조회 목록에서 Work명을 클릭하면 Configuration 정보를 조회할 수 있습니다.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- title end -->