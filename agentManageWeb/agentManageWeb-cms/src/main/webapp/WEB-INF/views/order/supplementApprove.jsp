<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div class="easyui-tabs">
    <div title="待审信息">
        <jsp:include page="supplementDetails.jsp"/>
        <table class="grid">
            <tr>
                <td> 实际付款金额:</td>
                <td colspan="6"><input name="realPayAmount" type="text" class="easyui-validatebox" style="width:120px;"
                                       data-options="required:true,validType:['length[1,20]','Money']" value="">/元
                </td>
            </tr>
        </table>

        <%@ include file="/commons/approval_opinion_supplementDetails.jsp" %>
        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'"
           onclick="submiSupplentApproval()">提交</a>
    </div>
    <shiro:hasPermission name="/agActivity/approvalRecordSee">
        <div title="审批记录">
            <%@ include file="/commons/approval_record.jsp" %>
        </div>
    </shiro:hasPermission>
    <div title="审批流程图">
        <shiro:hasPermission name="/agActivity/approvalRecordImgSee">
            <img src="/agActivity/approvalImage?taskId=${taskId}"/>
        </shiro:hasPermission>
    </div>
</div>
<script>

    function submiSupplentApproval() {
        var subApprovalTable = (typeof get_subApproval_FormDataItem === "function") ? get_subApproval_FormDataItem() : {};
        var oSupplement = (typeof get_suppDetail === "function") ? get_suppDetail() : {};
        var realPayAmount = $("input[name='realPayAmount']").val();
        $.ajaxL({
            type: "POST",
            url: "/supplement/taskApproval",
            dataType: 'json',
            contentType: 'application/json;charset=UTF-8',
            data: JSON.stringify({
                approvalOpinion: subApprovalTable.approvalOpinion,
                approvalResult: subApprovalTable.approvalResult,
                taskId: subApprovalTable.taskId,
                realPayAmount: realPayAmount,
                supplementId: oSupplement.supplementId
            }),
            beforeSend: function () {
                progressLoad();
            },
            success: function (msg) {
                info(msg.resInfo);
                if (msg.resCode == '1') {
                    $('#index_tabs').tabs('close', "${taskId}");
                    activityDataGrid.datagrid('reload');
                }
            },
            complete: function (XMLHttpRequest, textStatus) {
                progressClose();
            }
        });
    }
</script>