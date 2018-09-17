<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="业务信息"  data-options="iconCls:'fi-results'">
    <div class="easyui-tabs">
        <c:if test="${!empty agentBusInfos}">
            <c:forEach items="${agentBusInfos}" var="agentBusInfos">
            <div title="<c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                            <c:if test="${ablePlatFormItem.platformNum== agentBusInfos.busPlatform}">${ablePlatFormItem.platformName}</c:if>
                        </c:forEach>">
            <table class="grid">
                <tr >
                    <td>业务平台</td>
                    <td>
                        <c:forEach items="${ablePlatForm}" var="ablePlatFormItem">
                            <c:if test="${ablePlatFormItem.platformNum== agentBusInfos.busPlatform}">${ablePlatFormItem.platformName}</c:if>
                        </c:forEach>
                    </td>


                    <td>业务平台编号</td>
                    <td>${agentBusInfos.busNum}</td>
                    <td>类型</td>
                    <td>
                        <c:forEach items="${busType}" var="busTypeItem">
                            <c:if test="${busTypeItem.dItemvalue== agentBusInfos.busType}">${busTypeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>


                    <td>上级代理</td>
                    <td><agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busParent}"/>
                        <shiro:hasPermission name="/agentEnter/agentQuery/AgentBusiInfoParentStracture">
                        ||<a href="javascript:void(0);" onclick="showSynRegionFrame({
                                target:this,
                                callBack:agentQueryBusTreeCallBach
                                },'/region/busTreee?currentId=${agentBusInfos.id}',false)">业务结构</a>
                        </shiro:hasPermission>

                    </td>
                </tr>
                <tr >
                    <td>风险承担所属代理商</td>
                    <td><agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busRiskParent}"/></td>
                    <td>激活及返现所属代理商</td>
                    <td><agent:show type="agentBusIdForAgent" busId="${agentBusInfos.busActivationParent}"/></td>
                    <td>业务区域</td>
                    <td><agent:show type="posRegion" busId="${agentBusInfos.busRegion}"/></td>
                    <td>投诉及风险风控对接邮箱</td>
                    <td>${agentBusInfos.busRiskEmail}</td>
                </tr>
                <tr >
                    <td>业务联系人</td>
                    <td><desensitization:show type="name" value="${agentBusInfos.busContact}" jurisdiction="/agent/busNameSee"/></td>
                    <td>业务联系电话</td>
                    <td><desensitization:show type="mobile" value="${agentBusInfos.busContactMobile}" jurisdiction="/agent/busMobileSee"/></td>
                    <td>分润对接邮箱</td>
                    <td>${agentBusInfos.busContactEmail}</td>
                    <td>业务对接人</td>
                    <td><desensitization:show type="name" value="${agentBusInfos.busContactPerson}" jurisdiction="/agent/busNameSee"/></td>
                </tr>
                <tr >
                    <td>是否直发</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busSentDirectly}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    <td>是否直接返现</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busDirectCashback}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    <td>是否独立考核</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.busIndeAss}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>

                    <%--<td>是否开具分润发票</td>--%>
                    <%--<td>--%>
                        <%--<c:forEach items="${yesOrNo}" var="yesOrNoItem">--%>
                            <%--<c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.cloInvoice}">${yesOrNoItem.dItemname}</c:if>--%>
                        <%--</c:forEach>--%>
                    <%--</td>--%>
                    <td>是否要求收据</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                            <c:if test="${yesOrNoItem.dItemvalue== agentBusInfos.cloReceipt}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                </tr>
                <tr >
                    <%--<td>税点</td>--%>
                    <%--<td>${agentBusInfos.cloTaxPoint}</td>--%>
                    <td>打款公司</td>
                    <td>
                        <c:forEach items="${compList}" var="compListItem"  >
                            <c:if test="${compListItem.id== agentBusInfos.cloPayCompany}">${compListItem.comName}</c:if>
                        </c:forEach>
                    </td>
                    <td>分管协议</td>
                    <td>
                        <c:forEach items="${ass}" var="assItem"  >
                            <c:forEach items="${assProtoColRelList}" var="assProtoColRelListItem"  >
                                <c:if test="${assProtoColRelListItem.agentBusinfoId== agentBusInfos.id}">
                                <c:if test="${assProtoColRelListItem.assProtocolId== assItem.id}">
                                    ${assItem.protocolDes}
                                </c:if>
                                </c:if>
                            </c:forEach>
                        </c:forEach>
                    </td>
                    <td>财务编号</td>
                    <td>${agentBusInfos.agZbh}</td>
                    <td>使用范围</td>
                    <td>
                        <c:forEach items="${useScope}" var="useScopeItem"  >
                            <c:if test="${useScopeItem.dItemvalue == agentBusInfos.busUseOrgan}">${useScopeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                </tr>
                <tr>
                    <td>业务范围</td>
                    <td>
                        <c:forEach items="${busScope}" var="busScopeItem"  >
                            <c:if test="${busScopeItem.dItemvalue == agentBusInfos.busScope}">${busScopeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    <c:if test="${agentBusInfos.busPlatformType=='POS' || agentBusInfos.busPlatformType=='ZPOS'}">
                        <td>是否开通S0</td>
                        <td>
                            <c:forEach items="${yesOrNo}" var="yesOrNoItem">
                                <c:if test="${yesOrNoItem.dItemvalue == agentBusInfos.dredgeS0}">${yesOrNoItem.dItemname}</c:if>
                            </c:forEach>
                        </td>
                    </c:if>
                    <td>业务状态</td>
                    <td colspan="3" style="color: red">
                        <c:forEach items="${busStatus}" var="busStatusItem"  >
                            <c:if test="${busStatusItem.dItemvalue == agentBusInfos.busStatus}">${busStatusItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                </tr>
                <c:if test="${!empty agentBusInfos.agentColinfoList}">
                    <tr>
                        <td colspan="8" style="color: red">已分配收款账户：</td>
                    </tr>
                    <c:forEach items="${agentBusInfos.agentColinfoList}" var="agentColinfos">
                        <tr >
                            <td>收款账户类型</td>
                            <td>
                                <c:forEach items="${colInfoType}" var="colInfoTypeItem">
                                    <c:if test="${colInfoTypeItem.dItemvalue==agentColinfos.cloType}">${colInfoTypeItem.dItemname}</c:if>
                                </c:forEach>
                            </td>
                            <td>收款账户名</td>
                            <td>${agentColinfos.cloRealname}</td>
                            <td>收款总开户行</td>
                            <td>${agentColinfos.cloBank}</td>
                            <td>收款开户支行</td>
                            <td>${agentColinfos.cloBankBranch}</td>
                        </tr>
                        <tr>
                            <td>收款账号</td>
                            <td>${agentColinfos.cloBankAccount}</td>
                            <td>备注</td>
                            <td>${agentColinfos.remark}</td>
                        </tr>
                    </c:forEach>
                </c:if>

               </table>
            </div>
            </c:forEach>
        </c:if>
    </div>
</div>
<script type="application/javascript">
   function agentQueryBusTreeCallBach(data){

   }
</script>