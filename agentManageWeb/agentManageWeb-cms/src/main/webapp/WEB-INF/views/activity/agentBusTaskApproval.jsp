<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div class="easyui-tabs">
    <div title="待审信息">
        <%@ include file="/commons/queryAgentBase_model.jsp" %>
        <%@ include file="/commons/queryAgentcapital_model.jsp" %>
        <%@ include file="/commons/queryAgentContractTable_model.jsp" %>
        <%@ include file="/commons/queryAgentColinfoTable_model.jsp" %>
        <%@ include file="/commons/queryAgentBusi_model.jsp" %>
        <%@ include file="/commons/queryAttachment_model.jsp" %>
        <%--业务审批--%>
        <%@ include file="/commons/approval_business.jsp" %>
        <%--财务审批--%>
        <%@ include file="/commons/approval_account.jsp" %>
        <%--审批意见--%>
        <%@ include file="/commons/approval_opinion.jsp" %>
         <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'"  onclick="submitAgentBusApproval()" >提交</a>
    </div>
    <shiro:hasPermission name="/agActivity/approvalRecordSee">
    <div title="审批记录">
        <%@ include file="/commons/approval_record.jsp" %>
    </div>
    </shiro:hasPermission>
    <div title="审批流程图">
        <shiro:hasPermission name="/agActivity/approvalRecordImgSee">
            <img src="/agActivity/approvalImage?taskId=${taskId}" />
        </shiro:hasPermission>
    </div>
</div>
<script>

    function submitAgentBusApproval() {
        var addAgentAccountTable = (typeof get_addAgentAccountTable_FormDataItem === "function")?get_addAgentAccountTable_FormDataItem():[];
        var subApprovalTable = (typeof get_subApproval_FormDataItem === "function")?get_subApproval_FormDataItem():{};
        var payCompanyTable = (typeof get_payCompanyTable_FormDataItem === "function")?get_payCompanyTable_FormDataItem():[];
        var busEditTable = (typeof get_busEditTable_FormDataItem=== "function")?get_busEditTable_FormDataItem():[];

        var busInfoVoList = [];
        if(payCompanyTable!=''){
            busInfoVoList = payCompanyTable;
        }else if(busEditTable!=''){
            busInfoVoList = busEditTable;
        }
        var subFlag = false;
        if(payCompanyTable!=''){
            $.each( payCompanyTable, function(index, content) {
                if(content.cloPayCompany==''){
                    info("请分配打款公司！");
                    return false;
                }
                subFlag = true;
            });
        }else{
            subFlag = true;
        }
        if(subFlag){
            parent.$.messager.confirm('询问', '确认完成任务？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/agActivity/taskApproval",
                        dataType:'json',
                        contentType:'application/json;charset=UTF-8',
                        data: JSON.stringify({
                            agentColinfoRelList:addAgentAccountTable,
                            busInfoVoList:busInfoVoList,
                            approvalOpinion:subApprovalTable.approvalOpinion,
                            approvalResult:subApprovalTable.approvalResult,
                            taskId:subApprovalTable.taskId
                        }),
                        beforeSend:function(){
                            progressLoad();
                        },
                        success: function(msg){
                            info(msg.resInfo);
                            if(msg.resCode=='1'){
                                $('#index_tabs').tabs('close',"${taskId}");
                                activityDataGrid.datagrid('reload');
                            }
                        },
                        complete:function (XMLHttpRequest, textStatus) {
                            progressClose();
                        }
                    });
                }
            });
        }
    }

</script>
