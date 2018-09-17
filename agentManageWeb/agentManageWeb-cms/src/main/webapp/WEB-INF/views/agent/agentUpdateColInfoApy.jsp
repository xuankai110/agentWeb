<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>


<%@ include file="/commons/editAgentBasics_model.jsp" %>
<%--<%@ include file="/commons/editAgentCapital_model.jsp" %>--%>
<%--<%@ include file="/commons/editAgentContractTable_model.jsp" %>--%>
<%@ include file="/commons/editAgentColinfoTable_model.jsp" %>
<%--<%@ include file="/commons/editAgentBusi_model.jsp" %>--%>
<%--<%@ include file="/commons/editAttachment_model.jsp" %>--%>


<div style="text-align:right;padding:5px;margin-bottom: 50px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'" onclick="saveAgentColinfoEditApy()">保存</a>
</div>

<script type="text/javascript">
    function saveAgentColinfoEditApy(){
       var agent =get_editAgentBasics_FormData();
       var editAgentcapitalTable =(typeof get_editAgentcapitalTable_FormData=== "function")?get_editAgentcapitalTable_FormData():[];
       var editAgentContractTable =(typeof get_editAgentContractTable_FormData=== "function")?get_editAgentContractTable_FormData():[];
       var editAgentColinfoTable =(typeof get_editAgentColinfoTable_FormData=== "function")?get_editAgentColinfoTable_FormData():[];
        var editAgentBusiTable =(typeof get_editAgentBusiTable_FormData=== "function")?get_editAgentBusiTable_FormData():[];
        var AgentBase_AttFile_model_formFiles = (typeof get_addAttAgentcapitalTable_attrfiles=== "function")?get_addAttAgentcapitalTable_attrfiles():[];

        $.ajaxL({
           type: "POST",
            url: "/agentUpdateApy/agentColInfoUpdateApy",
            dataType:'json',
            contentType:'application/json;charset=UTF-8',
            data: JSON.stringify({
                agent: agent,
                capitalVoList:editAgentcapitalTable,
                contractVoList:editAgentContractTable,
                colinfoVoList:editAgentColinfoTable,
                busInfoVoList:editAgentBusiTable,
                agentTableFile:AgentBase_AttFile_model_formFiles
            }),
            success: function(msg){
               if(msg.resCode && msg.resCode=='1'){
                   info(msg.resInfo);
                   $('#index_tabs').tabs('close',"代理商收款信息修改申请"+agent.id);
               }else{
                   info(msg.resInfo);
               }
           },
            complete:function (XMLHttpRequest, textStatus) {

            }
        });

    }

</script>
