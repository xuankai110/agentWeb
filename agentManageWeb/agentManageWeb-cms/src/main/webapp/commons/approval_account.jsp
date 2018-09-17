<shiro:hasPermission name="/agActivity/approvalAccount">

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="easyui-panel" title="审批" data-options="iconCls:'fi-results'">
    <table class="grid" id="accountTableId">
        <tr>
            <td>结算业务类型</td>
            <td>打款公司分配</td>
            <td>收款账户</td>
        </tr>
        <c:forEach items="${agentBusInfoList}" var="agentBusInfo"  >
            <tr>
                <td>
                    <input type="hidden" name="agentbusPlatForm" value="${agentBusInfo.BUS_PLATFORM}">
                    <input type="hidden" name="agentbusid" value="${agentBusInfo.ID}">
                    <input type="hidden" name="agentAgentId" value="${agentBusInfo.AGENT_ID}">
                    <c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                        <c:if test="${ablePlatFormItem.platformNum== agentBusInfo.BUS_PLATFORM}">${ablePlatFormItem.platformName}</c:if>
                    </c:forEach>
                </td>
                <td>
                    <select name="cloPayCompany" style="width:160px;height:21px" >
                        <option value="" >请选择</option>
                        <c:forEach items="${compList}" var="compListItem"  >
                            <option value="${compListItem.id}" <c:if test="${agentBusInfo.PAYCOMANYID==compListItem.id}">selected</c:if>>${compListItem.comName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select name="agentColinfoid" id="agentColinfoid" style="width:320px;height:21px" >
                        <c:forEach items="${agentColinfos}" var="agentColinfos">
                            <option value="${agentColinfos.id}">
                                <c:forEach items="${colInfoType}" var="colInfoTypeItem">
                                    <c:if test="${colInfoTypeItem.dItemvalue==agentColinfos.cloType}">${colInfoTypeItem.dItemname}</c:if>
                                </c:forEach>
                                |${agentColinfos.cloRealname}
                                |${agentColinfos.cloBank}
                                |${agentColinfos.cloBankBranch}
                                |${agentColinfos.cloBankAccount}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
<script>

    function get_payCompanyTable_FormDataItem() {
        var formDataJson = [];
        $('#accountTableId tr').each(function(i){
            if(i>=1){
                var data = {};
                data.cloPayCompany  = $(this).find("select[name='cloPayCompany']").val();
                data.id  = $(this).find("input[name='agentbusid']").val();
                formDataJson.push(data);
            }
        });
        return formDataJson;
    }


    function get_addAgentAccountTable_FormDataItem() {
        var formDataJson = [];
        $('#accountTableId tr').each(function(i){
            if(i>=1){
                var data = {};
                data.agentColinfoid = $(this).find("select[name='agentColinfoid']").val();
                data.busPlatform = $(this).find("input[name='agentbusPlatForm']").val();
                data.agentbusid  = $(this).find("input[name='agentbusid']").val();
                data.agentid  = $(this).find("input[name='agentAgentId']").val();
                formDataJson.push(data);
            }
        });
       return formDataJson;
    }

</script>
</shiro:hasPermission>