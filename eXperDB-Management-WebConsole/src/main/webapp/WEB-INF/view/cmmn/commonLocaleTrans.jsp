<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   

<script type="text/javascript">
var menu_trans_management = "<spring:message code='menu.trans_management' />";
var migration_source_system = "<spring:message code='migration.source_system' />";
var migration_target_system = "<spring:message code='migration.target_system' />";

var migration_msg01 = "<spring:message code='migration.msg01' />";
var migration_msg04 = "<spring:message code='migration.msg04' />";
var migration_msg05 = "<spring:message code='migration.msg05' />";
var migration_msg06 = "<spring:message code='migration.msg06' />";

var eXperDB_CDC_msg10 = "<spring:message code='eXperDB_CDC.msg10' />";
var eXperDB_CDC_msg7 = "<spring:message code='eXperDB_CDC.msg7' />";
var eXperDB_CDC_msg17 = "<spring:message code='eXperDB_CDC.msg17' />";
var eXperDB_CDC_msg16 = "<spring:message code='eXperDB_CDC.msg16' />";
var eXperDB_CDC_msg13 = "<spring:message code='eXperDB_CDC.msg13' />";
var eXperDB_CDC_msg12 = "<spring:message code='eXperDB_CDC.msg12' />";
var eXperDB_CDC_msg11 = "<spring:message code='eXperDB_CDC.msg11' />";

var eXperDB_CDC_msg15 = "<spring:message code='eXperDB_CDC.msg15' />";
var eXperDB_CDC_msg14 = "<spring:message code='eXperDB_CDC.msg14' />";
var eXperDB_CDC_msg20 = "<spring:message code='eXperDB_CDC.msg20' />";
var eXperDB_CDC_msg19 = "<spring:message code='eXperDB_CDC.msg19' />";
var eXperDB_CDC_msg18 = "<spring:message code='eXperDB_CDC.msg18' />";
var eXperDB_CDC_msg22 = "<spring:message code='eXperDB_CDC.msg22' />";
var eXperDB_CDC_msg21 = "<spring:message code='eXperDB_CDC.msg21' />";
var eXperDB_CDC_msg28 = "<spring:message code='eXperDB_CDC.msg28' />";
var eXperDB_CDC_msg29 = "<spring:message code='eXperDB_CDC.msg29' />";

var eXperDB_CDC_transfer_activity = "<spring:message code='eXperDB_CDC.transfer_activity' />";
var eXperDB_CDC_msg23 = "<spring:message code='eXperDB_CDC.msg23' />";
var eXperDB_CDC_save_select_active = "<spring:message code='eXperDB_CDC.save_select_active' />";
var eXperDB_CDC_save_select_disabled = "<spring:message code='eXperDB_CDC.save_select_disabled' />";
var eXperDB_CDC_msg1 = "<spring:message code='eXperDB_CDC.msg1' />";
var eXperDB_CDC_msg2 = "<spring:message code='eXperDB_CDC.msg2' />";
var eXperDB_CDC_msg3 = "<spring:message code='eXperDB_CDC.msg3' />";
var eXperDB_CDC_msg4 = "<spring:message code='eXperDB_CDC.msg4' />";
var eXperDB_CDC_msg5 = "<spring:message code='eXperDB_CDC.msg5' />";

var eXperDB_CDC_connecting = "<spring:message code='eXperDB_CDC.connecting' />";

var eXperDB_CDC_msg34 = "<spring:message code='eXperDB_CDC.msg34' />";
var eXperDB_CDC_msg35 = "<spring:message code='eXperDB_CDC.msg35' />";

var message_act_start = "<spring:message code='eXperDB_proxy.act_start'/>";
var message_act_restart = "<spring:message code='eXperDB_proxy.act_restart'/>";
var message_act_stop = "<spring:message code='eXperDB_proxy.act_stop'/>";

var eXperDB_CDC_msg6 = "<spring:message code='eXperDB_CDC.msg6'/>";
var eXperDB_CDC_msg8 = "<spring:message code='eXperDB_CDC.msg8'/>";
var eXperDB_CDC_msg9 = "<spring:message code='eXperDB_CDC.msg9'/>";
var eXperDB_CDC_msg24 = "<spring:message code='eXperDB_CDC.msg24'/>";

var message_connect_name ="<spring:message code='eXperDB_CDC.connect_name'/>"
var message_source_error = "<spring:message code='eXperDB_CDC.source_error'/>";
var message_target_error = "<spring:message code='eXperDB_CDC.target_error'/>";
var message_source_record_write_total = "<spring:message code='eXperDB_CDC.source_record_write_total'/>";
var message_source_record_poll_total = "<spring:message code='eXperDB_CDC.source_record_poll_total'/>";
var message_source_record_active_count = "<spring:message code='eXperDB_CDC.source_record_active_count'/>";
var message_source_record_active_count_avg = "<spring:message code='eXperDB_CDC.source_record_active_count_avg'/>";
var message_source_record_write_rate = "<spring:message code='eXperDB_CDC.source_record_write_rate'/>";
var message_total_record_errors = "<spring:message code='eXperDB_CDC.total_record_errors'/>";
var message_total_record_failures = "<spring:message code='eXperDB_CDC.total_record_failures'/>";
var message_total_records_skipped = "<spring:message code='eXperDB_CDC.total_records_skipped'/>";
var message_total_retries = "<spring:message code='eXperDB_CDC.total_retries'/>";
var message_sink_record_active_count = "<spring:message code='eXperDB_CDC.sink_record_active_count'/>";
var message_sink_record_send_total = "<spring:message code='eXperDB_CDC.sink_record_send_total'/>";
var message_offset_commit_completion_total = "<spring:message code='eXperDB_CDC.offset_commit_completion_total'/>";
var message_offset_commit_skip_total = "<spring:message code='eXperDB_CDC.offset_commit_skip_total'/>";
var message_msg45 = "<spring:message code='eXperDB_CDC.msg45'/>";
var message_number_of_events_filtered = "<spring:message code='eXperDB_CDC.number_of_events_filtered'/>";
var message_number_of_erroneous_events = "<spring:message code='eXperDB_CDC.number_of_erroneous_events'/>";
var message_total_number_of_events_seen = "<spring:message code='eXperDB_CDC.total_number_of_events_seen'/>";

var eXperDB_CDC_msg30 = "<spring:message code='eXperDB_CDC.msg30' />";
var eXperDB_CDC_msg33 = "<spring:message code='eXperDB_CDC.msg33' />";
var eXperDB_CDC_msg38 = "<spring:message code='eXperDB_CDC.msg38' />";
var eXperDB_CDC_msg49 ="<spring:message code='eXperDB_CDC.msg49'/>";

var eXperDB_CDC_default_setting = "<spring:message code='eXperDB_CDC.default_setting'/>";



</script>
<body>

</body>
</html>