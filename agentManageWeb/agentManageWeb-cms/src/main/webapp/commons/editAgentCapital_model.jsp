<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="缴纳款项" data-options="iconCls:'fi-results', tools:'#editAgentcapital_model_tools' ">
    <form id="editAgentcapital_model_form">
            <c:if test="${!empty capitals}">
                <c:forEach items="${capitals}" var="capitals">
                    <table class="grid">
                        <tbody>
                    <tr class="jnkxTr">
                        <td>缴纳款项<input type="hidden" name="id" value="${capitals.id}"></td>
                        <td>
                            <select name="cType" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentCapitalInfo">disabled="true"</shiro:lacksPermission> >
                                <c:forEach items="${capitalType}" var="CapitalTypeItem"  >
                                    <option value="${CapitalTypeItem.dItemvalue}" <c:if test="${CapitalTypeItem.dItemvalue== capitals.cType}">selected="selected"</c:if>>${CapitalTypeItem.dItemname}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>缴纳金额</td>
                        <td><input name="cAmount" type="text"  class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,11]','Money']" value="${capitals.cAmount}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentCapitalInfo">readonly="readonly"</shiro:lacksPermission> /></td>
                        <td>打款时间</td>
                        <td><input name="cPaytime" type="text" editable="false" class="easyui-datebox"  style="width:160px;"  data-options="required:true"  value="<fmt:formatDate pattern="yyyy-MM-dd" value="${capitals.cPaytime}"/>" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentCapitalInfo">readonly="readonly"</shiro:lacksPermission> ></td>
                        <td>打款人</td>
                        <td><input name="remark" type="text"    class="easyui-validatebox"  style="width:160px;"   data-options="validType:['length[1,66]','CHS']" value="${capitals.remark}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentCapitalInfo">readonly="readonly"</shiro:lacksPermission> ></td>
                    </tr>
                    <tr>
                        <td>是否有效</td>
                        <td>
                            <select name="status" style="width:160px;height:21px" >
                                <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                    <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>附件</td>
                        <td class="attrInput" colspan="3">
                            <c:if test="${!empty capitals.attachmentList}">
                                <c:forEach items="${capitals.attachmentList}" var="attachment">
                                <span <shiro:hasPermission name="/agentEnter/agentEdit/AgentCapitalInfo"> onclick='removeaddEditAgentcapitalTable_jxkxUploadFile(this)'</shiro:hasPermission> >${attachment.attName}<input type='hidden' name='capitalTableFile' value='${attachment.id}' /></span>
                                </c:forEach>
                            </c:if>
                        </td>
                        <td colspan="4">
                            <shiro:hasPermission name="/agentEnter/agentEdit/AgentCapitalInfo">
                                <a href="javascript:void(0)" class="editAgentcapitalTableDel-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="removeEditAgentcapital_model(this)" >删除</a>||
                                <a href="javascript:void(0)" class="editAgentcapitalTableAddAttr-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="addEditAgentcapitalTable_uploadView(this)" >添加附件</a>
                            </shiro:hasPermission>
                        </td>
                    </tr>
                        </tbody>
                    </table>
                </c:forEach>
            </c:if>

    </form>
</div>

<shiro:hasPermission name="/agentEnter/agentEdit/AgentCapitalInfo">
<div id="editAgentcapital_model_tools">
    <a href="javascript:void(0)" class="icon-add" style="margin-right: 50px;" onclick="addEditAgentcapitalTable()"></a>
</div>
</shiro:hasPermission>

<div style="display: none" id="editAgentcapitalTable_model_templet">
    <table class="grid">
        <tbody>
        <tr class="jnkxTr">
            <td>缴纳款项</td>
            <td>
                <select name="cType" style="width:160px;height:21px" >
                    <c:forEach items="${capitalType}" var="CapitalTypeItem"  >
                        <option value="${CapitalTypeItem.dItemvalue}">${CapitalTypeItem.dItemname}</option>
                    </c:forEach>
                </select>
            </td>
            <td>缴纳金额</td>
            <td><input name="cAmount" type="text"  input-class="easyui-numberbox"  style="width:160px;"  data-options="required:true,validType:['length[1,11]','Money']"/></td>
            <td>打款时间</td>
            <td><input name="cPaytime" type="text"  input-class="easyui-datebox"  style="width:160px;" editable="false"  data-options="required:true"></td>
            <td>打款人</td>
            <td><input name="remark" type="text"  input-class="easyui-validatebox"  style="width:160px;"   data-options="validType:['length[1,66]','CHS']" ></td>
        </tr>
        <tr>
            <td>是否有效</td>
            <td>
                <select name="status" style="width:160px;height:21px" >
                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                        <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                    </c:forEach>
                </select>
            </td>
            <td>附件</td>
            <td class="attrInput" colspan="3">
            </td>
            <td colspan="4">
                <a href="javascript:void(0)" class="editAgentcapitalTableDel-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="removeEditAgentcapital_model(this)" >删除</a>||
                <a href="javascript:void(0)" class="editAgentcapitalTableAddAttr-easyui-linkbutton-edit" data-options="plain:true,iconCls:'fi-magnifying-glass'" onclick="addEditAgentcapitalTable_uploadView(this)" >添加附件</a>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<script>

    var addEditAgentcapitalTable_attrDom ;

    function addEditAgentcapitalTable(){
        $("#editAgentcapital_model_form").append($("#editAgentcapitalTable_model_templet").html());
        var inputs = $("#editAgentcapital_model_form .grid:last input");
        for(var i=0;i<inputs.length;i++){
            if($(inputs[i]).attr("input-class") && $(inputs[i]).attr("input-class").length>0)
                $(inputs[i]).addClass($(inputs[i]).attr("input-class"));
        }
        $.parser.parse($("#editAgentcapital_model_form .grid:last"));
    }

    //删除事件
    function removeEditAgentcapital_model(t){
        $(t).parent().parent().parent().parent().remove();
    }

    //上传窗口
    function addEditAgentcapitalTable_uploadView(t){
        addEditAgentcapitalTable_attrDom = $(t).parent().parent().find(".attrInput");
        multFileUpload(addEditAgentcapitalTable_jxkxUploadFile);
    }
    //附件解析
    function addEditAgentcapitalTable_jxkxUploadFile(data) {
        var jsondata = eval(data);
        for(var i=0;i<jsondata.length ;i++){
            $(addEditAgentcapitalTable_attrDom).append("<span onclick='removeaddEditAgentcapitalTable_jxkxUploadFile(this)'>"+jsondata[i].attName+"<input type='hidden' name='capitalTableFile' value='"+jsondata[i].id+"' /></span>&nbsp;&nbsp;&nbsp;&nbsp;");
        }

    }

    function removeaddEditAgentcapitalTable_jxkxUploadFile(t){
        parent.$.messager.confirm('询问', '确定删除附件么？', function(b) {
            if (b) {
                $(t).remove();
            }
        });
    }
    //解析打个table
    function get_editAgentcapitalTable_FormDataItem(table){
        var data = {};
        data.id = $(table).find("input[name='id']").length>0?$(table).find("input[name='id']").val():"";
        data.cType = $(table).find("select[name='cType']").val();
        data.cAmount = $(table).find("input[name='cAmount']").val();
        data.cPaytime = $(table).find("input[name='cPaytime']").val();
        data.remark = $(table).find("input[name='remark']").val();
        data.status = $(table).find("select[name='status']").val();
        var files =  $(table).find(".attrInput").find("input[name='capitalTableFile']");
        var capitalTableFileTemp = [];
        for(var j=0;j<files.length;j++){
            capitalTableFileTemp.push($(files[j]).val());
        }
        if(capitalTableFileTemp.length>0)
            data.capitalTableFile=capitalTableFileTemp;
        return data;
    }

    //获取form数据
    function get_editAgentcapitalTable_FormData(){
        var editAgentcapitalTable_FormDataJson = [];
        var tables = $("#editAgentcapital_model_form .grid");
        for (var  i=0;i<tables.length;i++){
            var table = tables[i];
            editAgentcapitalTable_FormDataJson.push(get_editAgentcapitalTable_FormDataItem(table));
        }
        return editAgentcapitalTable_FormDataJson;
    }
</script>