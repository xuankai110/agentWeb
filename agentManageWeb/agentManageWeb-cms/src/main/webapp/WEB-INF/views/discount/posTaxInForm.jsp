<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/angetJs.jsp" %>
<div class="easyui-panel" title="税点调整申请" data-options="iconCls:'fi-results'">
    <form id="posTaxBaseData">
        <table class="grid">
            <tr>
                <td width="360px">唯一编码：
                    <input id="agentPid" maxlength="30" type="text" placeholder="请输入" class="easyui-validatebox" data-options="required:true" style="width:160px;margin-left: 10px">
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="verifyAgent();">校验</a>
                </td>
                <td  width="360px"><a id="agentName"></a></td>
                <td  width="360px"><a id="taxOld"></a></td>
            </tr>
            <tr>
                <td width="360px">申请税点：
                    <input id="taxIng" maxlength="20" type="text" placeholder="请输入" class="easyui-validatebox" data-options="required:true" style="width:160px;">
                </td>
                <td></td><td></td>
            </tr>
        </table>
    </form>
</div>
<div style="text-align:right;padding:5px;margin-bottom: 50px;">
    <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 200px;" data-options="iconCls:'fi-save'"  onclick="saveposTaxEnterIn()">提交</a>
</div>

<script type="text/javascript">
    var agName = undefined;
    var cloTaxPoint = undefined;
    function alertMsg(msg) {
        parent.$.messager.alert('提示',msg, 'info');
    }

    //校验代理商
    function verifyAgent(agentPid) {
        //校验代理商 名称
        var agUniqNum = $("#agentPid").val();
        if(agUniqNum=='' || agUniqNum==undefined){
            alertMsg("唯一编号不能为空");
            return false;
        }
        $.ajax({
            url :"${path}/business/verifyAgent",
            type:'POST',
            data:{
                agUniqNum:agUniqNum
            },
            dataType:'json',
            success:function(data){
                if(data.success){
                    var jsonObj = JSON.parse(data.msg);
                    var text = "<a id=\"agentAname\" style=\"margin-left: 20px\">代理商名称："+jsonObj.agName+"</a>";
                    agName = jsonObj.agName;
                    $("#agentName").html(text);
                    $('input[name="agentPid"]').val(jsonObj.id);
                }else{
                    alertMsg(data.msg);
                    $('input[name="agentPid"]').val("");
                    $("#agentAname").remove();
                }
            },
            error:function(data){
                alertMsg("获取代理商失败，请联系管理员！");
            }
        });

        //校验代理商 原税点
        var agentId = $("#agentPid").val();
        if(agentId=='' || agentId==undefined){
            alertMsg("唯一编号不能为空");
            return false;
        }
        $.ajax({
            url :"${path}/discount/queryPoint",
            type:'POST',
            data:{
                agentId:agentId
            },
            dataType:'json',
            success:function(data){
                if(data.success){
                    var jsonObj = JSON.parse(data.msg);
                    var text = "<a id=\"taxPoint\" style=\"margin-left: 20px\">原税点："+jsonObj.cloTaxPoint+"</a>";
                    cloTaxPoint = jsonObj.cloTaxPoint;
                    $("#taxOld").html(text);
                    $('input[name="agentPid"]').val(jsonObj.id);
                }else{
                    alertMsg(data.msg);
                    $('input[name="agentPid"]').val("");
                    $("#taxPoint").remove();
                }
            },
            error:function(data){
                alertMsg("获取代理商失败，请联系管理员！");
            }
        });
    }


    var posTaxBase_AttFile_model_form_attrDom;

    //上传窗口
    function posTaxBase_AttFile_model_form_uploadView(t) {
        posTaxBase_AttFile_model_form_attrDom = $(t).parent().parent().find(".attrInput");
        multFileUpload(posTaxBase_AttFile_model_form_jxkxUploadFile);
    }

    //附件解析
    function posTaxBase_AttFile_model_form_jxkxUploadFile(data) {
        var jsondata = eval(data);
        for (var i = 0; i < jsondata.length; i++) {
            $(posTaxBase_AttFile_model_form_attrDom).append("<span onclick='removeFile(this)'>" + jsondata[i].attName + "<input type='hidden' name='posTaxBaseTableFile' value='" + jsondata[i].id + "' /></span>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
    }

    function removeFile(t){
        parent.$.messager.confirm('询问', '确定删除附件么？', function(b) {
            if (b) {
                $(t).remove();
            }
        });
    }

    function saveposTaxEnterIn() {
        var agentBase = $("#posTaxBaseData").form('validate');
        var agUniqNum = $("#agentPid").val();
        var agentId = $("#agentPid").val();
        var agUniqNam = agName;
        var xxOld = cloTaxPoint;
        var xxIng = $("#taxIng").val();
        if(agUniqNum=='' || agUniqNum==undefined){
            alertMsg("请输入代理商唯一编号！");
            return;
        }
        if(agentId=='' || agentId==undefined){
            alertMsg("请输入代理商唯一编号！");
            return;
        }
        if(agUniqNam=='' || agUniqNam==undefined){
            alertMsg("请校验获取代理商名称！");
            return;
        }
        if(xxOld=='' || xxOld==undefined){
            alertMsg("请校验获取原税点！");
            return;
        }
        if (agentBase) {
            parent.$.messager.confirm('询问', '确认提交申请？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/discount/posTaxEnterIn",
                        dataType:'json',
                        data: {
                            agNam:agUniqNam,
                            agNum:agUniqNum,
                            agPid:agentId,
                            old:xxOld,
                            ing:xxIng
                        },
                        beforeSend : function() {
                            progressLoad();
                        },
                        success: function(msg){
                            info(msg.resInfo);
                            if(msg.resCode=='1'){
                                $('#index_tabs').tabs('close',"优惠政策-申请税点调整");
                                posTaxList.datagrid('reload');
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


    function saveAndaudit() {
        var baseData = $.serializeObject($("#posTaxBaseData"));
        var addposTaxcapitalTable = (typeof get_addposTaxcapitalTable_FormData === "function") ? get_addposTaxcapitalTable_FormData() : [];
        var addposTaxContractTable = (typeof get_addposTaxContractTable_FormData === "function") ? get_addposTaxContractTable_FormData() : [];
        var addposTaxColinfoTable = (typeof get_addposTaxColinfoTable_FormData === "function") ? get_addposTaxColinfoTable_FormData() : [];
        var addposTaxBusiTable = (typeof get_addposTaxBusiTable_FormData === "function") ? get_addposTaxBusiTable_FormData() : [];
        if(addposTaxColinfoTable=='' || addposTaxColinfoTable==undefined){
            info("最少添加一个收款账户！");
            return;
        }
        if(addposTaxBusiTable=='' || addposTaxBusiTable==undefined){
            info("最少添加一个业务信息！");
            return;
        }

        var posTaxBase_AttFile_model_formFiles = $("#posTaxBase_AttFile_model_form").find("input");
        var files = [];
        for (var i = 0; i < posTaxBase_AttFile_model_formFiles.length; i++) {
            files.push($(posTaxBase_AttFile_model_formFiles[i]).val());
        }
        var posTaxBase = $("#posTaxBaseData").form('validate');
        var posTaxcapital = $("#posTaxcapital_model_form").form('validate');
        var posTaxContract = $("#posTaxContract_model_form").form('validate');
        var posTaxColinfo = $("#posTaxColinfoTable_model_form").form('validate');
        var posTaxBusi = $("#posTaxBusi_model").form('validate');

        if (posTaxBase && posTaxcapital && posTaxContract && posTaxColinfo && posTaxBusi) {
            parent.$.messager.confirm('询问', '确认要添加？', function(b) {
                if (b) {
                    $.ajaxL({
                        type: "POST",
                        url: "/posTaxEnter/saveAndaudit",
                        dataType:'json',
                        traditional:true,//这使json格式的字符不会被转码
                        contentType:'application/json;charset=UTF-8',
                        data: JSON.stringify({
                            posTax:baseData,
                            capitalVoList:addposTaxcapitalTable,
                            contractVoList:addposTaxContractTable,
                            colinfoVoList:addposTaxColinfoTable,
                            busInfoVoList:addposTaxBusiTable,
                            posTaxTableFile:files}),
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
</script>
