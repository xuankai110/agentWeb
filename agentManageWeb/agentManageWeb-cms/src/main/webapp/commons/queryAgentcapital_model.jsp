<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="easyui-panel" title="缴纳款项" data-options="iconCls:'fi-results'">
    <table class="grid">
        <c:if test="${!empty capitals}">
            <c:forEach items="${capitals}" var="capitals">
                <tr>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>缴纳款项</td>
                    <td>
                        <c:forEach items="${capitalType}" var="capitalTypeItem">
                            <c:if test="${capitalTypeItem.dItemvalue== capitals.cType}">${capitalTypeItem.dItemname}</c:if>
                        </c:forEach>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>缴纳金额</td>
                    <td>
                        ${capitals.cAmount}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>打款时间</td>
                    <td>
                            <fmt:formatDate pattern="yyyy-MM-dd" value="${capitals.cPaytime}"/>
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                    <td>打款人</td>
                    <td>
                        ${capitals.remark}
                    </td>
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/agent/businessDepShrio">
                        <c:if test="${!empty capitals.attachmentList}">
                            <c:forEach items="${capitals.attachmentList}" var="attachment">
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
