<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div class="easyui-panel" title="代理商基本信息" data-options="iconCls:'fi-results'">
    <form id="agentBaseData">
        <table class="grid">
            <input name="id" type="hidden" value=""/>
            <tr>
                <td>代理商名称</td>
                <td style="width:180px">
                    <input name="agName" id="agentName" type="text" class="easyui-validatebox" style="width:120px;"
                           data-options="required:true" value="">
                    <a href="javascript:void(0);" onclick="industrialAuth()">工商认证</a></td>
                    <input name="caStatus" id="caStatus" type="hidden" value="0">
                </td>
                <td>公司性质</td>
                <td>
                    <select name="agNature" style="width:160px;height:21px">
                        <c:forEach items="${agNatureType}" var="agnatureTypeItem">
                            <option value="${agnatureTypeItem.dItemvalue}">${agnatureTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>注册资本</td>
                <td><input name="agCapital" type="text" class="easyui-validatebox" style="width:120px;"
                           data-options="required:true,validType:['length[1,20]','Money']" value="">/万元</td>
                <td>营业执照</td>
                <td><input name="agBusLic" type="text" class="easyui-validatebox" style="width:120px;"
                           data-options="required:true,validType:'length[1,30]'"  value=""></td>
            </tr>
            <tr>
                <td>营业执照开始时间</td>
                <td><input name="agBusLicb" id="agBusLicb" type="text" class="easyui-datebox" editable="false" placeholder="请输入"
                           style="width:120px;" data-options="required:true" value=""></td>
                <td>营业执照到期日</td>
                <td>
                    <input name="agBusLice" id="agBusLice" type="text" class="easyui-datebox" editable="false" placeholder="请输入"
                           style="width:120px;" data-options="required:true" editable="false" value="">
                    <a href="javascript:void(0);" onclick="setAgBusLice()">无限期</a></td>
                </td>
                <td>负责人</td>
                <td><input name="agHead" type="text" class="easyui-validatebox" style="width:120px;" value=""
                           data-options="required:true,validType:['length[1,6]','CHS']"></td>
                <td>负责人联系电话</td>
                <td><input name="agHeadMobile" type="text" class="easyui-validatebox" style="width:120px;"
                           data-options="required:true,validType:['length[7,12]','Mobile']"  value=""></td>
            </tr>
            <tr>
                <td>法人证件类型</td>
                <td>
                    <select name="agLegalCertype" style="width:160px;height:21px">
                        <c:forEach items="${certType}" var="CertTypeItem" varStatus="certTypeStatus">
                            <option value="${CertTypeItem.dItemvalue}">${CertTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>法人证件号</td>
                <td><input name="agLegalCernum" type="text" class="easyui-validatebox" value=""
                           editable="false" placeholder="请输入" style="width:120px;" data-options="required:true,validType:'length[1,20]'"></td>
                <td>法人姓名</td>
                <td><input name="agLegal" type="text" class="easyui-validatebox" value="" style="width:120px;"
                           data-options="required:true,validType:['length[1,10]','CHS']"></td>
                <td>法人联系电话</td>
                <td><input name="agLegalMobile" type="text" class="easyui-validatebox" style="width:120px;"
                           data-options="required:true,validType:['length[7,12]','Mobile']" value=""></td>
            </tr>
            <tr>
                <td>注册地址</td>
                <td colspan="7"><input name="agRegAdd" type="text" class="easyui-validatebox" value=""
                                       style="width:80%;" data-options="required:true,validType:'length[1,333]'"></td>
            </tr>
            <tr>
                <%--<td>税点</td>--%>
                <%--<td><input name="cloTaxPoint" type="text" input-class="easyui-validatebox" style="width:80%;" readonly="readonly" value="6"--%>
                           <%--data-options="required:true,validType:['length[1,11]','Money']"></td>--%>
                <td>营业范围</td>
                <td><input name="agBusScope" type="text" class="easyui-validatebox" style="width:80%;" value=""
                           data-options="required:true,validType:'length[1,333]'"></td>
                <td>业务对接大区</td>
                <td>
                    <input type="text" id="agDocDistrict" input-class="easyui-validatebox" style="width:60%;" data-options="required:true" readonly="readonly" value="<agent:show type="dept" busId="${userOrg.ORGPID}" />">
                    <input name="agDocDistrict" type="hidden" value="${userOrg.ORGPID}" id="agDocDistricts"/>
                    <a href="javascript:void(0);"
                       onclick="showRegionFrame({target:this,callBack:returnNetInRegion},'/region/departmentTree',false)">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
                <td>业务对接省区</td>
                <td>
                    <input type="text" id="agDocPro" input-class="easyui-validatebox" style="width:60%;" data-options="required:true" readonly="readonly" value="<agent:show type="dept" busId="${userOrg.ORGID}" />">
                    <input name="agDocPro" type="hidden" value="${userOrg.ORGID}" id="agDocPros"/>
                    <a href="javascript:void(0);"onclick="showRegionFrame({target:this,callBack:returnNetInRegion,pid:$(this).parent().prev('td').prev('td').children('input[name=\'agDocDistrict\']').val()},'/region/departmentTree',false)">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
            </tr>
            <tr>
                <td>备注</td>
                <td colspan="7"><input name="agRemark" type="text" class="easyui-validatebox" value=""
                                       style="width:80%;"  data-options="validType:['length[1,66]','CHS']"></td>
            </tr>
        </table>
    </form>
</div>

<%@ include file="/commons/agentCapital_model.jsp" %>
<%@ include file="/commons/agentContractTable_model.jsp" %>
<%@ include file="/commons/agentColinfoTable_model.jsp" %>
<%@ include file="/commons/agentBusi_model.jsp" %>
<%@ include file="/commons/validate.jsp" %>
<div class="easyui-panel" title="添加附件" data-options="iconCls:'fi-results'">
    <form id="AgentBase_AttFile_model_form">
        <table class="grid">
            <tr>
                <td class="attrInput" colspan="4">
                </td>
                <td colspan="2">
                    <a href="javascript:void(0)" class="busck-easyui-linkbutton-edit"
                       data-options="plain:true,iconCls:'fi-magnifying-glass'"
                       onclick="AgentBase_AttFile_model_form_uploadView(this)">添加附件</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<shiro:hasPermission name="/agent/enterbutton" >
<div style="text-align:right;padding:5px;margin-bottom: 50px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'"  onclick="saveAgentEnterIn()">保存</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'"  onclick="saveAndaudit()">保存并审核</a>
</div>

</shiro:hasPermission>

<script type="text/javascript">

    //地区选择
    function returnNetInRegion(data,options){
        $(options.target).prev("input").val(data.id);
        $(options.target).prev("input").prev("input").val(data.text);
    }

    $(function () {
        //手动输入清除工商认证状态
        $('#agentName').bind('input propertychange', function() {
            $("#caStatus").val("0");
        });
    });

    var AgentBase_AttFile_model_form_attrDom;

    //上传窗口
    function AgentBase_AttFile_model_form_uploadView(t) {
        AgentBase_AttFile_model_form_attrDom = $(t).parent().parent().find(".attrInput");
        multFileUpload(AgentBase_AttFile_model_form_jxkxUploadFile);
    }

    //附件解析
    function AgentBase_AttFile_model_form_jxkxUploadFile(data) {
        var jsondata = eval(data);
        for (var i = 0; i < jsondata.length; i++) {
            $(AgentBase_AttFile_model_form_attrDom).append("<span onclick='removeFile(this)'>" + jsondata[i].attName + "<input type='hidden' name='agentBaseTableFile' value='" + jsondata[i].id + "' /></span>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
    }

    function removeFile(t){
        parent.$.messager.confirm('询问', '确定删除附件么？', function(b) {
            if (b) {
                $(t).remove();
            }
        });
    }

    function saveAgentEnterIn() {

        var baseData = $.serializeObject($("#agentBaseData"));
        var addAgentcapitalTable = (typeof get_addAgentcapitalTable_FormData === "function") ? get_addAgentcapitalTable_FormData() : [];
        var addAgentContractTable = (typeof get_addAgentContractTable_FormData === "function") ? get_addAgentContractTable_FormData() : [];
        var addAgentColinfoTable = (typeof get_addAgentColinfoTable_FormData === "function") ? get_addAgentColinfoTable_FormData() : [];
        var addAgentBusiTable = (typeof get_addAgentBusiTable_FormData === "function") ? get_addAgentBusiTable_FormData() : [];
        if(addAgentColinfoTable=='' || addAgentColinfoTable==undefined){
            info("最少添加一个收款账户！");
            return;
        }

        if(addAgentBusiTable=='' || addAgentBusiTable==undefined){
            info("最少添加一个业务信息！");
            return;
        }

        var AgentBase_AttFile_model_formFiles = $("#AgentBase_AttFile_model_form").find("input");
        var files = [];
        for (var i = 0; i < AgentBase_AttFile_model_formFiles.length; i++) {
            files.push($(AgentBase_AttFile_model_formFiles[i]).val());
        }
        var agentBase = $("#agentBaseData").form('validate');
        var agentcapital = $("#Agentcapital_model_form").form('validate');
        var agentContract = $("#AgentContract_model_form").form('validate');
        var agentColinfo = $("#AgentColinfoTable_model_form").form('validate');
        var agentBusi = $("#AgentBusi_model").form('validate');

        if (agentBase && agentcapital && agentContract && agentColinfo && agentBusi) {
            parent.$.messager.confirm('询问', '确认要添加？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/agentEnter/agentEnterIn",
                        dataType:'json',
                        traditional:true,//这使json格式的字符不会被转码
                        contentType:'application/json;charset=UTF-8',
                        data: JSON.stringify({
                            agent:baseData,
                            capitalVoList:addAgentcapitalTable,
                            contractVoList:addAgentContractTable,
                            colinfoVoList:addAgentColinfoTable,
                            busInfoVoList:addAgentBusiTable,
                            agentTableFile:files}),
                        beforeSend : function() {
                            progressLoad();
                        },
                        success: function(msg){
                            info(msg.resInfo);
                            if(msg.resCode=='1'){
                                $('#index_tabs').tabs('close',"代理商操作-新签代理商");
                                agnet_list_ConditionDataGrid.datagrid('reload');
                            }

                        },
                        complete:function (XMLHttpRequest, textStatus) {
                            progressClose();
                        }
                    });
                }
            });
        } else {
            info("请输入必填项")
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
                $("#caStatus").val("1");  //工商认证状态
                var dataObj = data.data;

                $("input[name='agCapital']").val(dataObj.regCap); //注册资金
                $("#agBusLicb").datebox("setValue",dataObj.openFrom); //经营开始日期
                if(dataObj.openTo=='长期'){
                    $("#agBusLice").datebox("setValue","2099-12-31");//经营结束日期
                }else{
                    $("#agBusLice").datebox("setValue",dataObj.openTo);//经营结束日期
                }
                $("input[name='agLegal']").val(dataObj.frName);  //法人姓名
                $("input[name='agRegAdd']").val(dataObj.address); //注册地址
                $("input[name='agBusScope']").val(dataObj.operateScope); //经营范围
                $("input[name='agBusLic']").val(dataObj.creditCode); //营业执照

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


    function saveAndaudit() {

        var baseData = $.serializeObject($("#agentBaseData"));
        var addAgentcapitalTable = (typeof get_addAgentcapitalTable_FormData === "function") ? get_addAgentcapitalTable_FormData() : [];
        var addAgentContractTable = (typeof get_addAgentContractTable_FormData === "function") ? get_addAgentContractTable_FormData() : [];
        var addAgentColinfoTable = (typeof get_addAgentColinfoTable_FormData === "function") ? get_addAgentColinfoTable_FormData() : [];
        var addAgentBusiTable = (typeof get_addAgentBusiTable_FormData === "function") ? get_addAgentBusiTable_FormData() : [];
        if(addAgentColinfoTable=='' || addAgentColinfoTable==undefined){
            info("最少添加一个收款账户！");
            return;
        }

        if(addAgentBusiTable=='' || addAgentBusiTable==undefined){
            info("最少添加一个业务信息！");
            return;
        }

        var AgentBase_AttFile_model_formFiles = $("#AgentBase_AttFile_model_form").find("input");
        var files = [];
        for (var i = 0; i < AgentBase_AttFile_model_formFiles.length; i++) {
            files.push($(AgentBase_AttFile_model_formFiles[i]).val());
        }
        var agentBase = $("#agentBaseData").form('validate');
        var agentcapital = $("#Agentcapital_model_form").form('validate');
        var agentContract = $("#AgentContract_model_form").form('validate');
        var agentColinfo = $("#AgentColinfoTable_model_form").form('validate');
        var agentBusi = $("#AgentBusi_model").form('validate');

        if (agentBase && agentcapital && agentContract && agentColinfo && agentBusi) {
            parent.$.messager.confirm('询问', '确认要添加？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/agentEnter/saveAndaudit",
                        dataType:'json',
                        traditional:true,//这使json格式的字符不会被转码
                        contentType:'application/json;charset=UTF-8',
                        data: JSON.stringify({
                            agent:baseData,
                            capitalVoList:addAgentcapitalTable,
                            contractVoList:addAgentContractTable,
                            colinfoVoList:addAgentColinfoTable,
                            busInfoVoList:addAgentBusiTable,
                            agentTableFile:files}),
                        beforeSend : function() {
                            progressLoad();
                        },
                        success: function(msg){
                            info(msg.resInfo);
                            if(msg.resCode=='1'){
                                $('#index_tabs').tabs('close',"代理商操作-新签代理商");
                                agnet_list_ConditionDataGrid.datagrid('reload');
                            }

                        },
                        complete:function (XMLHttpRequest, textStatus) {
                            progressClose();
                        }
                    });
                }
            });
        } else {
            info("请输入必填项")
        }
    }

    function setAgBusLice() {
        $("#agBusLice").datebox("setValue","2099-12-31");
    }
</script>
