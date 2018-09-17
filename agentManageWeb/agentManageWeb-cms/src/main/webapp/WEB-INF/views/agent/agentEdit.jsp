<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>


<%@ include file="/commons/editAgentBasics_model.jsp" %>
<%@ include file="/commons/editAgentCapital_model.jsp" %>
<%@ include file="/commons/editAgentContractTable_model.jsp" %>
<%@ include file="/commons/editAgentColinfoTable_model.jsp" %>
<%@ include file="/commons/editAgentBusi_model.jsp" %>
<%@ include file="/commons/editAttachment_model.jsp" %>
<%@ include file="/commons/validate.jsp" %>
<div style="text-align:right;padding:5px;margin-bottom: 50px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'" onclick="saveAgentEnterEdit()">保存</a>
</div>

<script type="text/javascript">
    $(function () {
        //手动输入清除工商认证状态
        $('#agentName').bind('input propertychange', function() {
            $("#caStatus").val("0");
        });
    });

    function saveAgentEnterEdit(){
       var agent =get_editAgentBasics_FormData();
       var editAgentcapitalTable =(typeof get_editAgentcapitalTable_FormData=== "function")?get_editAgentcapitalTable_FormData():[];
       var editAgentContractTable =(typeof get_editAgentContractTable_FormData=== "function")?get_editAgentContractTable_FormData():[];
       var editAgentColinfoTable =(typeof get_editAgentColinfoTable_FormData=== "function")?get_editAgentColinfoTable_FormData():[];
        var editAgentBusiTable =(typeof get_editAgentBusiTable_FormData=== "function")?get_editAgentBusiTable_FormData():[];
        var AgentBase_AttFile_model_formFiles = (typeof get_addAttAgentcapitalTable_attrfiles=== "function")?get_addAttAgentcapitalTable_attrfiles():[];
        var editAgentBase = $("#agentBasics").form('validate');
        var editAgentcapital = $("#editAgentcapital_model_form").form('validate');
        var editAgentContract = $("#editAgentContract_model_form").form('validate');
        var editAgentColinfo = $("#editAgentColinfoTable_model_form").form('validate');
        var editAgentBusi = $("#editAgentBusi_model").form('validate');

        if (editAgentBase && editAgentcapital && editAgentContract && editAgentColinfo && editAgentBusi) {
            parent.$.messager.confirm('询问', '确认要修改？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/agentEnter/agentEdit",
                        dataType: 'json',
                        contentType: 'application/json;charset=UTF-8',
                        data: JSON.stringify({
                            agent: agent,
                            capitalVoList: editAgentcapitalTable,
                            contractVoList: editAgentContractTable,
                            colinfoVoList: editAgentColinfoTable,
                            busInfoVoList: editAgentBusiTable,
                            agentTableFile: AgentBase_AttFile_model_formFiles
                        }),
                        success: function (msg) {
                            if (msg.resCode && msg.resCode == '1') {
                                info(msg.resInfo);
                                if (typeof refreshTabView == 'function') {
                                    try {
                                        refreshTabView(agent.id);
                                    } catch (e) {

                                    }
                                }
                                $('#index_tabs').tabs('close', "代理商信息修改");
                            } else {
                                info(msg.resInfo);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {

                        }
                    });
                }
            });
        }else {
            info("请输入必填项");
        }

    }

    function industrialAuth() {
        var agentName = $('#agentName').val();
        if (agentName == '' || agentName == undefined) {
            info("请填写代理商名称！");
            return;
        }

        $.ajax({
            url: "${path}/agent/businessCA",
            type: 'POST',
            data: {
                agentBusinfoName: agentName
            },
            dataType:'json',
            success:function(data){
                var status = data.status;
                if(status==404){
                    info("暂无该代理商信息");
                    return false;
                }
                if(status==500){
                    info("服务器异常，请联系管理员！");
                    return false;
                }
                var dataObj = data.data;
                $("#caStatus").val("1");  //工商认证状态
//                $("input[name='agBusLic']").val(dataObj.regNo);  //营业执照
                $("input[name='agCapital']").val(dataObj.regCap); //注册资金
                $("#agBusLicb").datebox("setValue",dataObj.openFrom); //经营开始日期
                if(dataObj.openTo=='长期'){
                    $("#agBusLice").datebox("setValue","2099-12-12");//经营结束日期
                }else{
                    $("#agBusLice").datebox("setValue",dataObj.openTo);//经营结束日期
                }
                $("input[name='agLegal']").val(dataObj.frName);  //法人姓名
                $("input[name='agRegAdd']").val(dataObj.address); //注册地址
                $("input[name='agBusScope']").val(dataObj.operateScope); //经营范围
                $("input[name='agBusLic']").val(dataObj.creditCode); //营业执照

//                $("input[name='agBusLic']").removeClass("validatebox-invalid");
                $("input[name='agCapital']").removeClass("validatebox-invalid");
                $("input[name='agLegal']").removeClass("validatebox-invalid");
                $("input[name='agRegAdd']").removeClass("validatebox-invalid");
                $("input[name='agBusScope']").removeClass("validatebox-invalid");
                $("input[name='agBusLicb']").removeClass("validatebox-invalid");
                $("input[name='agBusLice']").removeClass("validatebox-invalid");
                $("input[name='agBusLic']").removeClass("validatebox-invalid");
            },
            error:function(data){
                info("服务器异常，请联系管理员！");
            }
        });
    }

</script>
