<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="easyui-panel" title="业务信息" data-options="iconCls:'fi-results',tools:'#AgentBusi_model_tools'">
    <div class="easyui-tabs" id="AgentBusi_model">
    </div>
</div>

<div id="AgentBusi_model_tools">
    <a href="javascript:void(0)" class="icon-add" style="margin-right: 50px;" onclick="addAgentBusiTable_model()"></a>
</div>

<div id="AgentBusi_model_templet" style="display: none;">
    <div title="业务">
        <table class="grid">
            <tr>
                <td>业务平台</td>
                <td>
                    <select name="busPlatform" id="busPlatform" style="width:160px;height:21px" onchange="changBus(this)" >
                        <c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                            <option value="${ablePlatFormItem.platformNum}" platformType="${ablePlatFormItem.platformType}">${ablePlatFormItem.platformName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>业务平台编号</td>
                <td><input name="busNum" type="text" input-class="easyui-validatebox" style="width:200px;" data-options="validType:'length[1,32]'" id="busNum"/></td>
                <td>类型</td>
                <td>
                    <select name="busType" style="width:200px;height:21px" id="busSelect" onchange="busSelect($(this).parent().prev().prev().find('#busNum'),this)">
                        <c:forEach items="${busType}" var="BusTypeItem">
                            <option value="${BusTypeItem.dItemvalue}"
                                    busType="${BusTypeItem.dItemnremark}">${BusTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>上级代理</td>
                <td>
                    <input type="text" input-class="easyui-validatebox" id="busParent" style="width:100px;" readonly="readonly">
                    <input name="busParent" type="hidden" id="busParents"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().find('select[name=\'busPlatform\']').val()},callBack:returnAgentSele})">选择</a>||
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                    <shiro:hasPermission name="/agentEnter/agentQuery/AgentBusiInfoParentStracture">
                        ||<a href="javascript:void(0);" onclick="showSynRegionFrame({
                        target:this,
                        callBack:function(data){},
                        },'/region/busTreee?currentId='+$($(this).parent('td').find('input[name=\'busParent\']')).val(),false)">业务结构</a>
                    </shiro:hasPermission>
                </td>
            </tr>
            <tr>
                <td>风险承担所属代理商</td>
                <td>
                    <input type="text" input-class="easyui-validatebox" id="busRiskParent" style="width:100px;"
                           readonly="readonly"/>
                    <input name="busRiskParent" type="hidden" id="busRiskParents"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnAgentSele})">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>

                <td>激活及返现所属代理商</td>
                <td>
                    <input type="text" input-class="easyui-validatebox" id="busActivationParent" style="width:130px;"
                           readonly="readonly"/>
                    <input name="busActivationParent" type="hidden" id="busActivationParents"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnAgentSele})">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>

                <td>业务区域</td>
                <td>
                    <input type="text" input-class="easyui-validatebox" id="busRegion" style="width:130px;"
                           data-options="required:true" readonly="readonly">
                    <input name="busRegion" type="hidden" id="busRegions"/>
                    <a href="javascript:void(0);"
                       onclick="showRegionFrame({target:this,callBack:returnRegion},'/region/posRegionTree',false)">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>

                <td>投诉及风险风控对接邮箱</td>
                <td><input name="busRiskEmail" type="text" input-class="easyui-validatebox" style="width:160px;"
                           data-options="required:true,validType:'Email'"></td>
            </tr>
            <tr>
                <td>业务联系人</td>
                <td><input name="busContact" type="text" input-class="easyui-validatebox" style="width:160px;"
                           data-options="required:true,validType:['length[1,10]','CHS']"/></td>
                <td>业务联系电话</td>
                <td><input name="busContactMobile" type="text" input-class="easyui-validatebox" style="width:160px;"
                           data-options="required:true,validType:['length[7,12]','Mobile']"/></td>
                <td>分润对接邮箱</td>
                <td><input name="busContactEmail" type="text" input-class="easyui-validatebox" style="width:160px;"
                           data-options="required:true,validType:'Email'"></td>
                <td>业务对接人</td>
                <td><input name="busContactPerson" type="text" input-class="easyui-validatebox" style="width:160px;"
                           data-options="required:true,validType:['length[1,10]','CHS']"></td>
            </tr>
            <tr>
                <td>是否直发</td>
                <td>
                    <select name="busSentDirectly" style="width:160px;height:21px">
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>是否直接返现</td>
                <td>
                    <select name="busDirectCashback" style="width:160px;height:21px">
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>是否独立考核</td>
                <td>
                    <select name="busIndeAss" style="width:160px;height:21px">
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <%--<td>是否开具分润发票</td>--%>
                <%--<td>--%>
                <%--<select name="cloInvoice" style="width:160px;height:21px" >--%>
                <%--<c:forEach items="${yesOrNo}" var="yesOrNoItem"  >--%>
                <%--<option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>--%>
                <%--</c:forEach>--%>
                <%--</select>--%>
                <%--</td>--%>
                <td>是否要求收据</td>
                <td>
                    <select name="cloReceipt" style="width:160px;height:21px">
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <%--<td>税点</td>--%>
                <%--<td><input name="cloTaxPoint" type="text"  input-class="easyui-validatebox"  style="width:160px;"    data-options="required:true,validType:['length[1,11]','Money']"/></td>--%>
                <%--<td>打款公司</td>--%>
                <%--<td>--%>
                <%--<select name="cloPayCompany" style="width:160px;height:21px" >--%>
                <%--<option value="">请选择</option>--%>
                <%--<c:forEach items="${compList}" var="compListItem"  >--%>
                <%--<option value="${compListItem.id}">${compListItem.comName}</option>--%>
                <%--</c:forEach>--%>
                <%--</select>--%>
                <%--</td>--%>
                <td>分管协议</td>
                <td>
                    <select name="agentAssProtocol" style="width:160px;height:21px">
                        <option value="">请选择</option>
                        <c:forEach items="${ass}" var="assListItem">
                            <option value="${assListItem.id}">${assListItem.protocolDes}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>财务编号</td>
                <td><input name="agZbh" type="text" disabled input-class="easyui-validatebox" style="width:160px;"
                           data-options="validType:'length[1,50]'"/></td>
                <td>使用范围</td>
                <td>
                    <select name="busUseOrgan" style="width:160px;height:21px">
                        <c:forEach items="${useScope}" var="useScopeItem">
                            <option value="${useScopeItem.dItemvalue}">${useScopeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>业务范围</td>
                <td>
                    <select name="busScope" style="width:160px;height:21px">
                        <c:forEach items="${busScope}" var="busScopeItem">
                            <option value="${busScopeItem.dItemvalue}">${busScopeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="dredgeS0Class" style="display: none">是否开通S0</td>
                <td class="dredgeS0Class" style="display: none">
                    <select name="dredgeS0" style="width:160px;height:21px">
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </table>
    </div>
</div>

<script>
    function busSelect(busNumInput,bustype) {
        var busType = $(bustype).find("option:selected").attr("busType");
        if (1 == busType) {
            //可编辑的
            $(busNumInput).attr("disabled", true);
        } else if (0 == busType) {
            //不可编辑的
            $(busNumInput).attr("disabled", false);
        }
    }

    //代理商选择
    function returnAgentSele(data, srcData) {
        $(srcData.target).prev("input").val();
        $(srcData.target).prev("input").val(data.ID);
        $(srcData.target).prev("input").prev("input").val(data.AG_NAME);
    }

    //地区选择
    function returnRegion(data, options) {
        var id = data.id;
        var dataIds = $(options.target).prev("input").val();
        if(dataIds!=''){
            var idSplit = dataIds.split(",");
            for(var i=0;i<idSplit.length;i++){
                if(id==idSplit[i]){
                    info("该业务区域已选择！");
                    return;
                }
            }
        }
        if(id=='0' && dataIds!=''){
            info("全国已包括其他城市请清除后再选择全国！");
            return false;
        }
        $(options.target).prev("input").val($(options.target).prev("input").val() != '' ? $(options.target).prev("input").val() + "," + data.id : "" + data.id);
        $(options.target).prev("input").prev("input").val($(options.target).prev("input").prev("input").val() != '' ? $(options.target).prev("input").prev("input").val() + "," + data.text : "" + data.text);
    }

    function addAgentBusiTable_model(t) {
        $("#AgentBusi_model").tabs('add', {
            title: "代理商业务",
            content: $("#AgentBusi_model_templet").html(),
            closable: true
        });
        var inputs = $("#AgentBusi_model .grid:last input");
        for (var i = 0; i < inputs.length; i++) {
            if ($(inputs[i]).attr("input-class") && $(inputs[i]).attr("input-class").length > 0)
                $(inputs[i]).addClass($(inputs[i]).attr("input-class"));
        }
        $.parser.parse($("#AgentBusi_model .grid:last"));

    }

    //解析打个table
    function get_addAgentBusiTable_FormDataItem(table) {
        var data = {};
        data.busPlatform = $(table).find("select[name='busPlatform']").val();
        data.busNum = $(table).find("input[name='busNum']").val();
        data.busType = $(table).find("select[name='busType']").val();
        data.busParent = $(table).find("input[name='busParent']").val();
        data.busRiskParent = $(table).find("input[name='busRiskParent']").val();
        data.busActivationParent = $(table).find("input[name='busActivationParent']").val();
        data.busRegion = $(table).find("input[name='busRegion']").val();
        data.busRiskEmail = $(table).find("input[name='busRiskEmail']").val();
        data.busContact = $(table).find("input[name='busContact']").val();
        data.busContactMobile = $(table).find("input[name='busContactMobile']").val();
        data.busContactEmail = $(table).find("input[name='busContactEmail']").val();
        data.busContactPerson = $(table).find("input[name='busContactPerson']").val();
        data.busSentDirectly = $(table).find("select[name='busSentDirectly']").val();
        data.busDirectCashback = $(table).find("select[name='busDirectCashback']").val();
        data.busIndeAss = $(table).find("select[name='busIndeAss']").val();
        data.cloInvoice = $(table).find("select[name='cloInvoice']").val();
        data.cloReceipt = $(table).find("select[name='cloReceipt']").val();
        data.cloTaxPoint = $(table).find("input[name='cloTaxPoint']").val();
        data.cloPayCompany = $(table).find("select[name='cloPayCompany']").val();
        data.agentAssProtocol = $(table).find("select[name='agentAssProtocol']").val();
        data.agZbh = $(table).find("input[name='agZbh']").val();
        data.busUseOrgan = $(table).find("select[name='busUseOrgan']").val();
        data.busScope = $(table).find("select[name='busScope']").val();
        data.dredgeS0 = $(table).find("select[name='dredgeS0']").val();
        return data;
    }

    //获取form数据
    function get_addAgentBusiTable_FormData() {
        var addAgentBusiTable_FormDataJson = [];
        var tables = $("#AgentBusi_model .grid");
        for (var i = 0; i < tables.length; i++) {
            var table = tables[i];
            addAgentBusiTable_FormDataJson.push(get_addAgentBusiTable_FormDataItem(table));
        }
        return addAgentBusiTable_FormDataJson;
    }

    function changBus(o){
        var platformType = $(o).find("option:selected").attr("platformType");
        if(platformType=='POS' ||  platformType=='ZPOS'){
            $(o).parent().parent().parent().find(".dredgeS0Class").removeAttr("style");
        }else{
            $(o).parent().parent().parent().find(".dredgeS0Class").attr("style","display: none");
        }
    }
</script>


