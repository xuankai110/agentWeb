<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="easyui-panel" title="业务信息"  data-options="iconCls:'fi-results',tools:'#editAgentBusi_model_tools'">
    <div class="easyui-tabs" id="editAgentBusi_model">

                <c:if test="${!empty agentBusInfos}">
                    <c:forEach items="${agentBusInfos}" var="agentBusInfos">
                    <div title="代理商业务">
                        <table  class="grid">
                        <tr >
                            <td>业务平台<input name="id" type="hidden"   value="${agentBusInfos.id}"/></td>
                            <td>
                                <select name="busPlatform" style="width:200px;height:21px" onchange="changBus(this)" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >
                                    <c:forEach items="${ablePlatForm}" var="ablePlatFormItem"  >
                                        <option value="${ablePlatFormItem.platformNum}" platformType="${ablePlatFormItem.platformType}" <c:if test="${ablePlatFormItem.platformNum== agentBusInfos.busPlatform}">selected="selected"</c:if> >${ablePlatFormItem.platformName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>业务平台编号</td>
                            <td><input name="busNum" id="busNums" type="text"  class="easyui-validatebox"  style="width:200px;"  data-options="validType:'length[1,32]'" value="${agentBusInfos.busNum}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission>/></td>
                            <td>类型</td>
                            <td>
                                <select name="busType" style="width:200px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> onchange="busTypeSelect($(this).parent().prev().prev().find('#busNums'),this)" id="busTypeSelect">
                                    <c:forEach items="${busType}" var="BusTypeItem"  >
                                        <option value="${BusTypeItem.dItemvalue}" busNums="${BusTypeItem.dItemnremark}" <c:if test="${BusTypeItem.dItemvalue== agentBusInfos.busType}">selected="selected"</c:if>>${BusTypeItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>上级代理</td>
                            <td>
                                <input  type="text" readonly="readonly" class="easyui-validatebox" id="busParent1"  style="width:100px;"  data-options="required:true" value="<agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busParent}" />" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission>  >
                                <input name="busParent" type="hidden" value="${agentBusInfos.busParent}" id="busParent2"/>
                                <shiro:hasPermission name="/agentEnter/agentEdit/AgentBusiInfo">
                                <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                                target:this,
                                urlpar:'?busPlatform='+$(this).parent().parent().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>||
                                </shiro:hasPermission>
                                <a href="javascript:void(0);" onclick="del(this)">清除</a>
                                <shiro:hasPermission name="/agentEnter/agentQuery/AgentBusiInfoParentStracture">
                                    ||<a href="javascript:void(0);" onclick="showSynRegionFrame({
                                    target:this,
                                    callBack:function(data){},
                                    },'/region/busTreee?currentId='+$($(this).parent('td').find('input[name=\'busParent\']')).val(),false)">业务结构</a>
                                </shiro:hasPermission>
                            </td>

                        </tr>
                        <tr >
                            <td>风险承担所属代理商</td>
                            <td>
                                <input  type="text" class="easyui-validatebox" readonly="readonly" id="busRiskParent3" style="width:100px;"  data-options="required:true" value="<agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busRiskParent}"/>" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> />
                                <input name="busRiskParent" type="hidden" value="${agentBusInfos.busRiskParent}" id="busRiskParent4"/>
                                <shiro:hasPermission name="/agentEnter/agentEdit/AgentBusiInfo">
                                <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                                    target:this,
                                    urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>
                                </shiro:hasPermission>
                                <a href="javascript:void(0);" onclick="del(this)">清除</a>
                            </td>

                            <td>激活及返现所属代理商</td>
                            <td>
                                <input  type="text"  class="easyui-validatebox"id="busActivationParent1" readonly="readonly" style="width:130px;"  data-options="required:true" value="<agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busActivationParent}"/>" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> />
                                <input name="busActivationParent" type="hidden" value="${agentBusInfos.busActivationParent}" id="busActivationParent2"/>
                                <shiro:hasPermission name="/agentEnter/agentEdit/AgentBusiInfo">
                                <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                                target:this,
                                urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>
                                </shiro:hasPermission>
                                <a href="javascript:void(0);" onclick="del(this)">清除</a>
                            </td>

                            <td>业务区域</td>
                            <td>
                                <input type="text"  class="easyui-validatebox"  readonly="readonly" id="busRegion1" style="width:130px;"  data-options="required:true" value="<agent:show type="posRegion" busId="${agentBusInfos.busRegion}"/>" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> />
                                <input name="busRegion" type="hidden" value="${agentBusInfos.busRegion}" id="busRegion2"/>
                                <shiro:hasPermission name="/agentEnter/agentEdit/AgentBusiInfo">
                                <a href="javascript:void(0);" onclick="showRegionFrame({target:this,callBack:returnEditRegion},'/region/posRegionTree',false)">选择</a>
                                </shiro:hasPermission>
                                <a href="javascript:void(0);" onclick="del(this)">清除</a>
                            </td>

                            <td>投诉及风险风控对接邮箱</td>
                            <td><input name="busRiskEmail" type="text"  class="easyui-validatebox"  style="width:160px;" data-options="required:true,validType:'Email'" value="${agentBusInfos.busRiskEmail}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> ></td>
                        </tr>
                        <tr >
                            <td>业务联系人</td>
                            <td><input name="busContact" type="text"  class="easyui-validatebox"  style="width:160px;" data-options="required:true,validType:['length[1,10]','CHS']" value="${agentBusInfos.busContact}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> /></td>
                            <td>业务联系电话</td>
                            <td><input name="busContactMobile" type="text"  class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[7,12]','Mobile']" value="${agentBusInfos.busContactMobile}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> /></td>
                            <td>分润对接邮箱</td>
                            <td><input name="busContactEmail" type="text"  class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:'Email'" value="${agentBusInfos.busContactEmail}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> ></td>
                            <td>业务对接人</td>
                            <td><input name="busContactPerson" type="text"  class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,10]','CHS']" value="${agentBusInfos.busContactPerson}" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission> ></td>
                        </tr>
                        <tr >
                            <td>是否直发</td>
                            <td>
                                <select name="busSentDirectly" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                        <option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busSentDirectly}"> selected="selected"</c:if>>${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>是否直接返现</td>
                            <td>
                                <select name="busDirectCashback" style="width:160px;height:21px"  <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                        <option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busDirectCashback}">selected="selected"</c:if>>${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>是否独立考核</td>
                            <td>
                                <select name="busIndeAss" style="width:160px;height:21px"  <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                        <option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busIndeAss}">selected="selected"</c:if>>${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <%--<td>是否开具分润发票</td>--%>
                            <%--<td>--%>
                                <%--<select name="cloInvoice" style="width:160px;height:21px"  <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >--%>
                                    <%--<c:forEach items="${yesOrNo}" var="yesOrNoItem"  >--%>
                                        <%--<option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.cloInvoice}">selected="selected"</c:if>>${yesOrNoItem.dItemname}</option>--%>
                                    <%--</c:forEach>--%>
                                <%--</select>--%>
                            <%--</td>--%>
                            <td>是否要求收据</td>
                            <td>
                                <select name="cloReceipt" style="width:160px;height:21px"  <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission> >
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                        <option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.cloReceipt}">selected="selected"</c:if>>${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr >
                            <%--<td>税点</td>--%>
                            <%--<td><input name="cloTaxPoint" type="text"  class="easyui-validatebox"  style="width:160px;"   data-options="required:true,validType:['length[1,11]','Money']" value="${agentBusInfos.cloTaxPoint}"  <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> readonly="readonly" </shiro:lacksPermission>  /></td>--%>
                            <%--<td>打款公司</td>--%>
                            <%--<td>--%>
                                <%--<select name="cloPayCompany" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission>  >--%>
                                    <%--<option value="">请选择</option>--%>
                                    <%--<c:forEach items="${compList}" var="compListItem"  >--%>
                                        <%--<option value="${compListItem.id}" <c:if test="${compListItem.id== agentBusInfos.cloPayCompany}">selected="selected"</c:if>>${compListItem.comName}</option>--%>
                                    <%--</c:forEach>--%>
                                <%--</select>--%>
                            <%--</td>--%>
                            <td>分管协议</td>
                            <td>

                                <select name="agentAssProtocol" style="width:160px;height:21px" <shiro:lacksPermission name="/agentEnter/agentEdit/AgentBusiInfo"> disabled="true" </shiro:lacksPermission>>
                                    <option value="">请选择</option>
                                    <c:forEach items="${ass}" var="assListItem"  >
                                        <option value="${assListItem.id}"
                                               <c:forEach items="${assProtoColRelList}" var="assProtoColRelListItem"  >
                                                    <c:if test="${assProtoColRelListItem.agentBusinfoId==agentBusInfos.id}">
                                                        <c:if test="${assProtoColRelListItem.assProtocolId== assListItem.id}">
                                                            selected="selected"
                                                        </c:if>
                                                    </c:if>
                                                </c:forEach>
                                        >${assListItem.protocolDes}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>财务编号</td>
                            <td><input name="agZbh" type="text" disabled input-class="easyui-validatebox"  style="width:160px;"  data-options="validType:'length[1,50]'" value="${agentBusInfos.agZbh}"/></td>
                            <td>使用范围</td>
                            <td>
                                <select name="busUseOrgan" style="width:160px;height:21px" >
                                    <c:forEach items="${useScope}" var="useScopeItem"  >
                                        <option value="${useScopeItem.dItemvalue}" <c:if test="${useScopeItem.dItemvalue == agentBusInfos.busUseOrgan}">selected="selected"</c:if> >${useScopeItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>业务范围</td>
                            <td>
                                <select name="busScope" style="width:160px;height:21px" >
                                    <c:forEach items="${busScope}" var="busScopeItem"  >
                                        <option value="${busScopeItem.dItemvalue}" <c:if test="${busScopeItem.dItemvalue == agentBusInfos.busScope}">selected="selected"</c:if> >${busScopeItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="dredgeS0Class" <c:if test="${agentBusInfos.busPlatformType!='POS' && agentBusInfos.busPlatformType!='ZPOS'}">style="display: none"</c:if>>是否开通S0</td>
                            <td class="dredgeS0Class" <c:if test="${agentBusInfos.busPlatformType!='POS' && agentBusInfos.busPlatformType!='ZPOS'}">style="display: none"</c:if>>
                                <select name="dredgeS0" style="width:160px;height:21px">
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                                        <option value="${yesOrNoItem.dItemvalue}" <c:if test="${yesOrNoItem.dItemvalue == agentBusInfos.dredgeS0}">selected="selected"</c:if> >${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>业务状态</td>
                            <td>
                                <select name="busStatus" style="width:160px;height:21px"  >
                                    <c:forEach items="${busStatus}" var="busStatusItem"  >
                                        <option value="${busStatusItem.dItemvalue}" <c:if test="${busStatusItem.dItemvalue == agentBusInfos.busStatus}">selected="selected"</c:if> >${busStatusItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>是否有效</td>
                            <td>
                                <select name="status" style="width:160px;height:21px" >
                                    <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                                        <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        </table>
                    </div>
                    </c:forEach>
                </c:if>

    </div>
</div>
<shiro:hasPermission name="/agentEnter/agentEdit/AgentBusiInfo">
<div id="editAgentBusi_model_tools">
    <a href="javascript:void(0)" class="icon-add" style="margin-right: 50px;" onclick="editAgentBusiTable_model()"></a>
</div>
</shiro:hasPermission>
<div id="editAgentBusi_model_templet" style="display: none;">
    <div title="业务">
        <table  class="grid">
            <tr >
                <td>业务平台</td>
                <td>
                    <select name="busPlatform" style="width:200px;height:21px" onchange="changBus(this)">
                        <c:forEach items="${ablePlatForm}" var="ablePlatFormItem"  >
                            <option value="${ablePlatFormItem.platformNum}" platformType="${ablePlatFormItem.platformType}">${ablePlatFormItem.platformName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>业务平台编号</td>
                <td><input name="busNum"id="busNum" type="text"  input-class="easyui-validatebox"  style="width:200px;"  data-options="validType:'length[1,32]'"/></td>
                <td>类型</td>
                <td>
                    <select name="busType" style="width:200px;height:21px"  onchange="busNum($(this).parent().prev().prev().find('#busNum'),this)" id="busType">
                        <c:forEach items="${busType}" var="BusTypeItem"  >
                            <option value="${BusTypeItem.dItemvalue}" busNum="${BusTypeItem.dItemnremark}">${BusTypeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>上级代理</td>
                <td>
                    <input  type="text" readonly="readonly" id="busParent3" input-class="easyui-validatebox"  style="width:100px;"  data-options="required:true">
                    <input name="busParent" type="hidden" id="busParent4"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>||
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                    <shiro:hasPermission name="/agentEnter/agentQuery/AgentBusiInfoParentStracture">
                        ||<a href="javascript:void(0);" onclick="showSynRegionFrame({
                        target:this,
                        callBack:function(data){},
                        },'/region/busTreee?currentId='+$($(this).parent('td').find('input[name=\'busParent\']')).val(),false)">业务结构</a>
                    </shiro:hasPermission>
                </td>

            </tr>
            <tr >
                <td>风险承担所属代理商</td>
                <td>
                    <input  type="text" readonly="readonly" input-class="easyui-validatebox" id="busRiskParent1"  style="width:100px;"  data-options="required:true"/>
                    <input name="busRiskParent" type="hidden" id="busRiskParent2"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
                <td>激活及返现所属代理商</td>
                <td>
                    <input  type="text" readonly="readonly" input-class="easyui-validatebox" id="busActivationParent3" style="width:130px;"  data-options="required:true"/>
                    <input name="busActivationParent" type="hidden" id="busActivationParent4"/>
                    <a href="javascript:void(0);" onclick="showAgentSelectDialog({data:{
                        target:this,
                        urlpar:'?busPlatform='+$(this).parent().parent().prev().find('select[name=\'busPlatform\']').val()},callBack:returnEditAgentSele})">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
                <td>业务区域</td>
                <td>
                    <input type="text" readonly="readonly" input-class="easyui-validatebox" id="busRegion3" style="width:130px;"  data-options="required:true">
                    <input name="busRegion" type="hidden" id="busRegion4"/>
                    <a href="javascript:void(0);" onclick="showRegionFrame({target:this,callBack:returnEditRegion},'/region/posRegionTree',false)">选择</a>
                    <a href="javascript:void(0);" onclick="del(this)">清除</a>
                </td>
                <td>投诉及风险风控对接邮箱</td>
                <td><input name="busRiskEmail" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:'Email'"></td>
            </tr>
            <tr >
                <td>业务联系人</td>
                <td><input name="busContact" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,3]','CHS']"/></td>
                <td>业务联系电话</td>
                <td><input name="busContactMobile" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[7,12]','Mobile']"/></td>
                <td>分润对接邮箱</td>
                <td><input name="busContactEmail" type="text"  input-class="easyui-validatebox"  style="width:160px;" data-options="required:true,validType:'Email'"></td>
                <td>业务对接人</td>
                <td><input name="busContactPerson" type="text"  input-class="easyui-validatebox"  style="width:160px;"   data-options="required:true,validType:['length[1,3]','CHS']"></td>
            </tr>
            <tr >
                <td>是否直发</td>
                <td>
                    <select name="busSentDirectly" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>是否直接返现</td>
                <td>
                    <select name="busDirectCashback" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>是否独立考核</td>
                <td>
                    <select name="busIndeAss" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
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
                    <select name="cloReceipt" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr >
                <%--<td>税点</td>--%>
                <%--<td><input name="cloTaxPoint" type="text"  input-class="easyui-validatebox"  style="width:160px;"  data-options="required:true,validType:['length[1,11]','Money']"/></td>--%>
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
                    <select name="agentAssProtocol" style="width:160px;height:21px" >
                        <option value="">请选择</option>
                        <c:forEach items="${ass}" var="assListItem"  >
                            <option value="${assListItem.id}">${assListItem.protocolDes}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>财务编号</td>
                <td><input name="agZbh" type="text" disabled input-class="easyui-validatebox"  style="width:160px;"  data-options="validType:'length[1,50]'" /></td>
                <td>使用范围</td>
                <td>
                    <select name="busUseOrgan" style="width:160px;height:21px" >
                        <c:forEach items="${useScope}" var="useScopeItem"  >
                            <option value="${useScopeItem.dItemvalue}">${useScopeItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>业务范围</td>
                <td>
                    <select name="busScope" style="width:160px;height:21px" >
                        <c:forEach items="${busScope}" var="busScopeItem"  >
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
                <td>业务状态</td>
                <td>
                    <select name="busStatus" style="width:160px;height:21px" >
                        <c:forEach items="${busStatus}" var="busStatusItem"  >
                            <option value="${busStatusItem.dItemvalue}">${busStatusItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>是否有效</td>
                <td>
                    <select name="status" style="width:160px;height:21px" >
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <option value="${yesOrNoItem.dItemvalue}">${yesOrNoItem.dItemname}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </table>
    </div>
</div>

<script>

    function busNum(busInput,value) {
        var busType = $(value).find("option:selected").attr("busNum");
        if (1 == busType) {
            //可编辑的
            $(busInput).attr("disabled", true);
        } else if (0 == busType) {
            //不可编辑的
            $(busInput).attr("disabled", false);
        }
    }
    function busTypeSelect(input,t) {
        var busType = $(t).find("option:selected").attr("busNums");
        if (1 == busType) {
            //可编辑的
            $(input).attr("disabled", true);
        } else if (0 == busType) {
            //不可编辑的
            $(input).attr("disabled", false);
        }
    }


    //代理商选择
    function returnEditAgentSele(data,srcData){
        $(srcData.target).prev("input").val(data.ID);
        $(srcData.target).prev("input").prev("input").val(data.AG_NAME);
    }
    //地区选择
    function returnEditRegion(data,options){
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
        $(options.target).prev("input").val($(options.target).prev("input").val()!=''?$(options.target).prev("input").val()+","+data.id:""+data.id);
        $(options.target).prev("input").prev("input").val($(options.target).prev("input").prev("input").val()!=''?$(options.target).prev("input").prev("input").val()+","+data.text:""+data.text);
    }


    function editAgentBusiTable_model(t){
        $("#editAgentBusi_model").tabs('add',{
            title:"代理商业务",
            content:$("#editAgentBusi_model_templet").html(),
            closable:true
        });
        var inputs = $("#editAgentBusi_model .grid:last input");
        for(var i=0;i<inputs.length;i++){
            if($(inputs[i]).attr("input-class") && $(inputs[i]).attr("input-class").length>0)
                $(inputs[i]).addClass($(inputs[i]).attr("input-class"));
        }
        $.parser.parse($("#editAgentBusi_model .grid:last"));

    }
    //解析打个table
    function get_editAgentBusiTable_FormDataItem(table){
        var data = {};
        data.id = $(table).find("input[name='id']").length>0?$(table).find("input[name='id']").val():"";
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
        data.agentAssProtocol= $(table).find("select[name='agentAssProtocol']").val();
        data.agZbh= $(table).find("input[name='agZbh']").val();
        data.busStatus= $(table).find("select[name='busStatus']").val();
        data.status = $(table).find("select[name='status']").val();
        data.busUseOrgan = $(table).find("select[name='busUseOrgan']").val();
        data.busScope = $(table).find("select[name='busScope']").val();
        data.dredgeS0 = $(table).find("select[name='dredgeS0']").val();
        return data;
    }

    //获取form数据
    function get_editAgentBusiTable_FormData(){
        var editAgentBusiTable_FormDataJson = [];
        var tables = $("#editAgentBusi_model .grid");
        for (var  i=0;i<tables.length;i++){
            var table = tables[i];
            editAgentBusiTable_FormDataJson.push(get_editAgentBusiTable_FormDataItem(table));
        }
        return editAgentBusiTable_FormDataJson;
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


