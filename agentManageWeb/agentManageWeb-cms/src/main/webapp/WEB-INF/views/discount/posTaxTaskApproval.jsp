<%--标签 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" isELIgnored="false" session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="agent" uri="/WEB-INF/tld/agent.tld" %>
<%@ taglib prefix="desensitization" uri="/WEB-INF/tld/desensitization.tld" %>
<%--ctxPath--%>
<c:set var="ctxPath" value="${pageContext.request.contextPath}" />
<%--项目路径 --%>
<c:set var="path" value="${ctxPath}" />
<%--静态文件目录 --%>
<c:set var="staticPath" value="${ctxPath}" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script>
    function submitApproval() {
        var subApprovalTable = (typeof get_subApproval_FormDataItem=== "function")?get_subApproval_FormDataItem():[];
        var busEditTable = (typeof get_busEditTable_FormDataItem=== "function")?get_busEditTable_FormDataItem():[];
        var addAgentAccountTable = (typeof get_addAgentAccountTable_FormDataItem=== "function")?get_addAgentAccountTable_FormDataItem():[];

        var busInfoVoList = [];
        if(busEditTable!=''){
            busInfoVoList = busEditTable;
        }

        parent.$.messager.confirm('询问', '确认完成任务？', function(b) {
            if (b) {
                $.ajaxL({
                    type: "POST",
                    url: "/rewardActivity/taskApproval",
                    dataType:'json',
                    contentType:'application/json;charset=UTF-8',
                    data: JSON.stringify({
                        approvalOpinion:subApprovalTable.approvalOpinion,
                        approvalResult:subApprovalTable.approvalResult,
                        taskId:subApprovalTable.taskId,
                        orderAprDept:subApprovalTable.dept,
                        agentColinfoRelList:addAgentAccountTable,
                        busInfoVoList:busInfoVoList
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

    function refreshTabView() {
        refreshTab();
    }

    //驳回修改信息
    function editPosTax(){
        parent.$.messager.confirm('询问', '您确定申请信息填写完毕吗？', function(b) {
            if (b) {
                $.ajaxL({
                    type: "POST",
                    url: "/discount/editPosTaxRegect",
                    dataType:'json',
                    traditional:true,
                    contentType:"application/x-www-form-urlencoded",
                    data: $('#posPosTaxEditFrom').serializeArray(),
                    beforeSend : function() {
                        progressLoad();
                    },
                    success: function(msg){
                        if (msg.success) {
                            info("税点调整修改成功！");
                        }else {
                            info("系统异常，请联系运维人员！");
                        }
                    },
                    complete:function (XMLHttpRequest, textStatus) {
                        progressClose();
                    }
                });
            }
        });
    }
</script>
<div class="easyui-tabs" id="taskAppTabs">
    <div title="待审信息">
        <shiro:hasPermission name="/thaw/posTaxApprovalQuery">
            <%@ include file="posTaxInfo.jsp" %>
        </shiro:hasPermission>
        <shiro:hasPermission name="/thaw/posTaxApprovalUpdate">
            <%@ include file="posTaxEdit.jsp" %>
        </shiro:hasPermission>
        <%--审批意见--%>
        <%@ include file="rewardApproval_opinion.jsp" %>
        <shiro:hasPermission name="/thaw/posTaxApprovalUpdate">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="editPosTax()" >修改调整</a>
        </shiro:hasPermission>
        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'" onclick="submitApproval()">提交</a>
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
