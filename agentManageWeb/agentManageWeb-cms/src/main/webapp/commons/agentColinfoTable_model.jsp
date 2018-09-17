<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="收款账户"  data-options="iconCls:'fi-results',tools:'#AgentColinfoTable_model_tools'">
    <form id="AgentColinfoTable_model_form">
    </form>
</div>
<%--<shiro:hasPermission name="/agentEnter/agentEdit/AgentColinfoInfo">--%>
<%--<div id="AgentColinfoTable_model_tools">--%>
    <%--<a href="javascript:void(0)" class="icon-add" style="margin-right: 50px;" onclick="addAgentColinfoTable_model()"></a>--%>
<%--</div>--%>
<%--</shiro:hasPermission>--%>
<div style="display: none;" id="AgentColinfoTable_model_templet">
    <table class="grid">
        <tbody>
        <tr >
            <td>收款账户类型</td>
            <td>
                <select name="cloType" style="width:160px;height:21px" >
                    <c:forEach items="${colInfoType}" var="ColInfoTypeItem"  >
                        <option value="${ColInfoTypeItem.dItemvalue}">${ColInfoTypeItem.dItemname}</option>
                    </c:forEach>
                </select>
            </td>
            <td>收款账户名</td>
            <td><input name="cloRealname" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,100]','CHS']"/></td>
            <td>收款账号</td>
            <td>
                <input name="cloBankAccount" type="text"  input-class="easyui-validatebox"  style="width:130px;" data-options="required:true,validType:['length[1,20]','Number']" value="6222023500021111111">
                <a href="javascript:void(0);" onclick="discernCardNo(this)">识别</a>
            </td>
            <td>收款开户总行</td>
            <td><input name="cloBank" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,200]','CHS']"></td>
        </tr>
        <tr>
            <td>开户行地区</td>
            <td>
                <input type="text"  input-class="easyui-validatebox" id="bankRegion" style="width:100px;"  data-options="required:true"  readonly="readonly">
                <input name="bankRegion" type="hidden" id="bankRegions"/>
                <a href="javascript:void(0);" onclick="showRegionFrame({target:this,callBack:returnBankRegion},'/region/regionTree',false)">选择</a>
                <a href="javascript:void(0);" onclick="del('busRegion','busRegions')">清除</a>
            </td>
            <td>收款开户支行</td>
            <td class="branchTd">
                <input class="easyui-combobox" name="cloBankBranch" id="cloBankBranch"data-options="valueField:'id',textField:'text',panelHeight:'auto',panelMaxHeight:200,panelMinHeight:100"  style="width: 160px;height: 29px"/>
            </td>
            <td>总行联行号</td>
            <td><input name="allLineNum" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,32]','CHS']"></td>
            <td>支行联行号</td>
            <td><input name="branchLineNum" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,32]','CHS']"></td>
              <%--  <span class="star">*</span></td>--%>
        </tr>
        <tr>
            <td>税点</td>
            <td><input name="cloTaxPoint" type="text" input-class="easyui-validatebox" style="width:80%;" value="0.06"
                       data-options="required:true,validType:['length[1,11]','Money']"></td>
            <td>是否开具分润发票</td>
            <td>
                <select name="cloInvoice" style="width:160px;height:21px" >
                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                        <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                    </c:forEach>
                </select>
            </td>
            <td>备注</td>
            <td><input name="remark" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="validType:['length[1,66]','CHS']"></td>
        </tr>
        <tr>
            <td>附件</td>
            <td colspan="2" class="attrInput" ></td>
            <td>
                <%--<a href="javascript:void(0)" class="addAgentColinfoTabledel-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="removeAgentColinfoTable_model(this)" >删除</a>||--%>
                <a href="javascript:void(0)" class="addAgentColinfoTableAttr-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="addAgentColinfoTable_uploadView(this)" >添加附件</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<script>
    var cloBankId = "";
    $(function () {
        addAgentColinfoTable_model();
    });
    function addAgentColinfoTable_model(){
        $("#AgentColinfoTable_model_form").append($("#AgentColinfoTable_model_templet").html());
        var inputs = $("#AgentColinfoTable_model_form .grid:last input");
        for(var i=0;i<inputs.length;i++){
            if($(inputs[i]).attr("input-class") && $(inputs[i]).attr("input-class").length>0)
            $(inputs[i]).addClass($(inputs[i]).attr("input-class"));
        }
        $.parser.parse($("#AgentColinfoTable_model_form .grid:last"));
    }
    function removeAgentColinfoTable_model(t){
        $(t).parent().parent().parent().parent().remove();
    }

    var addAgentColinfoTable_attrDom ;

    //上传窗口
    function addAgentColinfoTable_uploadView(t){
        addAgentColinfoTable_attrDom = $(t).parent().parent().find(".attrInput");
        multFileUpload(addAgentColinfoTable_jxkxUploadFile);
    }

    //附件解析
    function addAgentColinfoTable_jxkxUploadFile(data) {
        var jsondata = eval(data);
        for(var i=0;i<jsondata.length ;i++){
            $(addAgentColinfoTable_attrDom).append("<span onclick='removeAgentColinfoTable_jxkxUploadFile(this)'>"+jsondata[i].attName+"<input type='hidden' name='colinfoTableFile' value='"+jsondata[i].id+"' /></span>&nbsp;&nbsp;&nbsp;&nbsp;");
        }

    }
    function removeAgentColinfoTable_jxkxUploadFile(t){
        parent.$.messager.confirm('询问', '确定删除附件么？', function(b) {
            if (b) {
                $(t).remove();
            }
        });
    }
    //解析打个table
    function get_addAgentColinfoTable_FormDataItem(table){
        var data = {};
        data.cloType = $(table).find("select[name='cloType']").val();
        data.cloRealname = $(table).find("input[name='cloRealname']").val();
        data.cloBank = $(table).find("input[name='cloBank']").val();
        data.cloBankBranch = $(table).find("input[name='cloBankBranch']").val();
        data.cloBankAccount = $(table).find("input[name='cloBankAccount']").val();
        data.remark = $(table).find("input[name='remark']").val();
        data.allLineNum = $(table).find("input[name='allLineNum']").val();
        data.branchLineNum = $(table).find("input[name='branchLineNum']").val();
        data.bankRegion = $(table).find("input[name='bankRegion']").val();
        data.cloTaxPoint = $(table).find("input[name='cloTaxPoint']").val();
        data.cloInvoice = $(table).find("select[name='cloInvoice']").val();
        var files =  $(table).find(".attrInput").find("input[name='colinfoTableFile']");
        var colinfoTableFileTemp = [];
        for(var j=0;j<files.length;j++){
            colinfoTableFileTemp.push($(files[j]).val());
        }
        if(colinfoTableFileTemp.length>0)
        data.colinfoTableFile=colinfoTableFileTemp;
        return data;
    }
    //获取form数据
    function get_addAgentColinfoTable_FormData(){
        var addAgentColinfoTable_FormDataJson = [];
        var tables = $("#AgentColinfoTable_model_form .grid");
        for (var  i=0;i<tables.length;i++){
            var table = tables[i];
            addAgentColinfoTable_FormDataJson.push(get_addAgentColinfoTable_FormDataItem(table));
        }
        return addAgentColinfoTable_FormDataJson;
    }

    function discernCardNo(obj) {
        var bankCardNo =$(obj).parent("td").find("input").val();
        if(bankCardNo=='' || bankCardNo==undefined){
            info("卡号不可为空！");
            return false;
        }
//        if(bankCardNo.length<10){
//            info("卡号长度有误！");
//            return false;
//        }
        $.ajax({
            url :"${path}/etbSysCard/queryCardNo",
            type:'POST',
            data:{
                bankCardNo:bankCardNo
            },
            dataType:'json',
            success:function(result){
                if(result.msg!='' && result.msg!=undefined){
                    info(result.msg);
                    return false;
                }
                cloBankId = result.issUsers;
                $(obj).parent().parent().parent().find("input[name='cloBank']").val(result.bankName);
                $(obj).parent().parent().parent().find("input[name='cloBank']").removeClass("validatebox-invalid");
            },
            error:function(data){
                info("系统异常，请联系管理员！");
            }
        });
    }

    //地区选择
    function returnBankRegion(data,options){
        if(data.tType>2){
            info("开户行地区只能选择市级以上");
            return false;
        }
        $(options.target).prev("input").val(data.id);
        $(options.target).prev("input").prev("input").val(data.text);
        if(cloBankId!='' && data.id!=''){
            $('#cloBankBranch').combobox({
                prompt:'输入首关键字自动检索',
                required:false,
                url:'/etbSysCard/queryLineNumList?cloBankId='+cloBankId+"&regionId="+data.id,
                editable:true,
                hasDownArrow:true,
                filter: function(q, row){
                    var opts = $(this).combobox('options');
                    return row[opts.textField].indexOf(q) == 0;
                },
                onChange: function (n,o) {
                    var data = $(this).combobox("getData");
                    var bankBranchId = "";
                    var liqBankId = "";
                    for(var i=0;i<data.length;i++){
                        if(data[i].text==n){
                            bankBranchId = data[i].bankBranchId;
                            liqBankId = data[i].liqBankId;
                        }
                    }
                    $("input[name='allLineNum']").val(liqBankId);
                    $("input[name='branchLineNum']").val(bankBranchId);
                    $("input[name='allLineNum']").removeClass("validatebox-invalid");
                    $("input[name='branchLineNum']").removeClass("validatebox-invalid");
                }
            });
        }
    }

</script>
