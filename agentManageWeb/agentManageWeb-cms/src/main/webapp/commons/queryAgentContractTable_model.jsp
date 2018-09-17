<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="easyui-panel" title="合同信息"  data-options="iconCls:'fi-results'">
    <table class="grid">
        <c:if test="${!empty agentContracts}">
            <c:forEach items="${agentContracts}" var="agentContracts" >
                <tr >
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>合同类型</td>
                    <td>
                        <c:forEach items="${contractType}" var="contractTypeItem">
                            <c:if test="${contractTypeItem.dItemvalue==agentContracts.contType}">${contractTypeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>合同号</td>
                    <td>
                        ${agentContracts.contNum}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>合同签约时间</td>
                    <td>
                        <fmt:formatDate pattern="yyyy-MM-dd" value="${agentContracts.contDate}" />
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>合同到期时间</td>
                    <td>
                        <fmt:formatDate pattern="yyyy-MM-dd" value="${agentContracts.contEndDate}" />
                    </td>
                    </shiro:hasPermission>
                </tr>
                <tr>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>是否附加协议</td>
                    <td>
                        <c:forEach items="${yesOrNo}" var="yesOrNoItem"  >
                            <c:if test="${yesOrNoItem.dItemvalue == agentContracts.appendAgree}">${yesOrNoItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>备注</td>
                    <td>
                        ${agentContracts.remark}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                        <c:if test="${!empty agentContracts.attachmentList}">
                            <c:forEach items="${agentContracts.attachmentList}" var="attachment">
                                <td>附件名称</td>
                                <td><a href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true">${attachment.attName}</a></td>
                                <td><a href="<%=imgPath%>${attachment.attDbpath}" class="easyui-linkbutton" data-options="plain:true" target="_blank" >查看附件</a></td>
                            </c:forEach>
                        </c:if>
                    </shiro:hasPermission>
                </tr>
            </c:forEach>
        </c:if>
    </table>
</div>