<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="收款账户"  data-options="iconCls:'fi-results'">
    <table class="grid">
        <c:if test="${!empty agentColinfos}">
            <c:forEach items="${agentColinfos}" var="agentColinfos">
                <tr >
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>收款账户类型</td>
                    <td>
                        <c:forEach items="${colInfoType}" var="colInfoTypeItem">
                            <c:if test="${colInfoTypeItem.dItemvalue==agentColinfos.cloType}">${colInfoTypeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>收款账户名</td>
                    <td>
                        ${agentColinfos.cloRealname}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>收款账号</td>
                    <td>
                        <desensitization:show type="card" value="${agentColinfos.cloBankAccount}" jurisdiction="/agent/busBankCardSee"/>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>收款开户总行</td>
                    <td>
                        ${agentColinfos.cloBank}
                    </td>
                    </shiro:hasPermission>
                </tr>
                <tr>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>开户行地区</td>
                    <td>
                        <agent:show type="region" busId="${agentColinfos.bankRegion}"/>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>收款开户支行</td>
                    <td>
                        ${agentColinfos.cloBankBranch}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>总行联行号</td>
                    <td>
                        ${agentColinfos.allLineNum}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>支行联行号</td>
                    <td>
                        ${agentColinfos.branchLineNum}
                    </td>
                    </shiro:hasPermission>
                </tr>
                <tr>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>税点</td>
                    <td>
                        ${agentColinfos.cloTaxPoint}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>是否开具分润发票</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem" >
                            <c:if test="${yesOrNoItem.dItemvalue==agentColinfos.cloInvoice}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>备注</td>
                    <td>
                        ${agentColinfos.remark}
                    </td>
                    </shiro:hasPermission>
                </tr>
                <shiro:hasPermission name="/agent/businessDepShrio">
                <tr>
                    <c:if test="${!empty agentColinfos.attachmentList}">
                        <c:forEach items="${agentColinfos.attachmentList}" var="attachment">
                            <td>附件名称</td>
                            <td><a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true">${attachment.attName}</a></td>
                            <td><a href="<%=imgPath%>${attachment.attDbpath}" class="easyui-linkbutton" data-options="plain:true" target="_blank" >查看附件</a></td>
                        </c:forEach>
                    </c:if>
                </tr>
                </shiro:hasPermission>
            </c:forEach>
        </c:if>
    </table>
</div>